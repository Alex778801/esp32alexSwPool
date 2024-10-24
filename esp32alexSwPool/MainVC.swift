//
//  MainViewViewController.swift
//  esp32alexSwPool
//
//  Created by Alexey Sorokin on 21.10.2024.
//

import UIKit
import Alamofire
import SwiftyJSON
import Eureka

var state = [String:Any]()

func sendCommand(_ cmd: String) {
    AF.request(Settings.shared.addr + "/exec?cmd=\(cmd)", method: .get)
      .authenticate(username: Settings.shared.login, password: Settings.shared.pwd)
      .response { response in
          debugPrint(response)
      }
}

class MainVC: FormViewController {
    
    @IBAction func resetBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Внимание!", message: "Перезагрузить контроллер?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Перезагрузка", style: .destructive, handler: { _ in
            //--
            sendCommand("reset")
            //--
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in }))
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func saveEEPROMBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Внимание!", message: "Сохранить текущие настройки в EEPROM?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Сохранить", style: .destructive, handler: { _ in
            //--
            sendCommand("config-set|1304|\(state["targetTemp"]!)")
//            sendCommand("config-save")
            //--
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in }))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func refreshBtn(_ sender: Any) {
        refreshData()
    }

    func switchCmd(rid: String?, value: Bool?) {
        if rid == nil || value == nil || !setupFinished { return }
        let rid = rid!.suffix(1)
        let cmd = "relay|\(rid)|\(b2s(value)!)"
        sendCommand(cmd)
    }
    
    private var setupFinished = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.frame = CGRect(x: 0, y: (self.tableView?.frame.origin.y)!, width: (self.tableView?.frame.size.width)!-20, height: (self.tableView?.frame.size.height)!)
    
        form  +++ Section("Состояние агрегатов")
        <<< SwitchRow(){ $0.title = "Насос фильтра:";       $0.tag = Settings.shared.pumpRelayID; $0.baseCell.isUserInteractionEnabled = false;}
        <<< SwitchRow(){ $0.title = "Нагрев от котла:";     $0.tag = Settings.shared.heaterRelayID; $0.baseCell.isUserInteractionEnabled = false; }
        <<< DecimalRow(){ $0.title = "t подачи котла:";     $0.tag = Settings.shared.heaterOutTrmId; $0.baseCell.isUserInteractionEnabled = false; }
        <<< DecimalRow(){ $0.title = "t обратки котла:";    $0.tag = Settings.shared.heaterInTrmId; $0.baseCell.isUserInteractionEnabled = false; }
        <<< DecimalRow(){ $0.title = "Давление теплоносителя:"; $0.tag = Settings.shared.heaterPrsID; $0.baseCell.isUserInteractionEnabled = false; }
        <<< DecimalRow(){ $0.title = "Давление в фильтре:";     $0.tag = Settings.shared.filterPrsID; $0.baseCell.isUserInteractionEnabled = false; }
        <<< DecimalRow(){ $0.title = "Уровень воды:";           $0.tag = Settings.shared.waterLevelID; $0.baseCell.isUserInteractionEnabled = false; }
        +++ Section("Освещение")
        <<< SwitchRow(){ $0.title = "Внешний свет:";        $0.tag = Settings.shared.lightExtRelayID }
            .onChange{ row in self.switchCmd(rid: Settings.shared.lightExtRelayID, value: row.value) }
        <<< SwitchRow(){ $0.title = "Подстветка воды:";     $0.tag = Settings.shared.lightWaterRelayID }
            .onChange{ row in self.switchCmd(rid: Settings.shared.lightWaterRelayID, value: row.value) }
        +++ Section("Температура воды")
        <<< DecimalRow(){ $0.title = "Текущая:";            $0.tag = Settings.shared.waterTrmId; $0.baseCell.isUserInteractionEnabled = false; }
        <<< SliderRow(){ $0.title = "Желаемая:";            $0.tag = "targetT"; $0.cell.slider.minimumValue = 15; $0.cell.slider.maximumValue = 35 }
            .onChange { row in state.updateValue(row.value!, forKey: "targetTemp") }
        <<< ButtonRow(){ $0.title = "Применить"}
            .onCellSelection{ _,_ in sendCommand("auto|0|t|\(state["targetTemp"]!)") }
        
        refreshData()
        DispatchQueue.main.asyncAfter(deadline: .now() + Settings.shared.refreshPeriod) {
            if Settings.shared.autoRefresh {
                self.refreshData()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.setupFinished = true }
    
    }
    
    func refreshData() {
        struct DecodableType: Decodable { let url: String }
        AF.request(Settings.shared.addr).responseString() { response in
            if let data = response.value?.data(using: .utf8) {
                if let json = try? JSON(data: data) {
//                    print(json)
                    state.updateValue( n2b(json[Settings.shared.pumpRelayID].int) as Any, forKey: Settings.shared.pumpRelayID)
                    state.updateValue( n2b(json[Settings.shared.heaterRelayID].int) as Any, forKey: Settings.shared.heaterRelayID)
                    state.updateValue( n2b(json[Settings.shared.lightWaterRelayID].int) as Any, forKey: Settings.shared.lightWaterRelayID)
                    state.updateValue( n2b(json[Settings.shared.lightExtRelayID].int) as Any, forKey: Settings.shared.lightExtRelayID)
                    state.updateValue( json[Settings.shared.waterTrmId].double as Any, forKey: Settings.shared.waterTrmId)
                    state.updateValue( json[Settings.shared.heaterInTrmId].double as Any, forKey: Settings.shared.heaterInTrmId)
                    state.updateValue( json[Settings.shared.heaterOutTrmId].double as Any, forKey: Settings.shared.heaterOutTrmId)
                    state.updateValue( json[Settings.shared.heaterPrsID]["v"].double as Any, forKey: Settings.shared.heaterPrsID)
                    state.updateValue( json[Settings.shared.filterPrsID]["v"].double as Any, forKey: Settings.shared.filterPrsID)
                    state.updateValue( json[Settings.shared.waterLevelID]["v"].double as Any, forKey: Settings.shared.waterLevelID)
                    // !!! Надо написать извчление
//                    state.updateValue( 12.34, forKey: "targetTemp")
//                    print(self.state)
                    self.form.setValues(state)
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
}
