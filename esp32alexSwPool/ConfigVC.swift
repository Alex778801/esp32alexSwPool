//
//  ConfigVC.swift
//  esp32alexSwPool
//
//  Created by Alexey Sorokin on 22.10.2024.
//

import UIKit
import Eureka

class ConfigVC: FormViewController {
    
    func saveSettings() {
        let alert = UIAlertController(title: "Внимание!", message: "Записать текущие настройки?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Записать", style: .destructive, handler: { _ in
            //--
            for row in self.form.allRows {
                if let name = row.tag {
                    if row is TextRow {
                        let value = (row as! TextRow).value!.trimmingCharacters(in: .whitespacesAndNewlines)
                        Settings.shared.set(value: value, key: name)
                    } else if row is PasswordRow  {
                        let value = (row as! PasswordRow).value!.trimmingCharacters(in: .whitespacesAndNewlines)
                        Settings.shared.set(value: value, key: name)
                    } else if row is DecimalRow {
                        let value = (row as! DecimalRow).value!
                        Settings.shared.set(value: value, key: name)
                    } else if row is SwitchRow {
                        let value = (row as! SwitchRow).value!
                        Settings.shared.set(value: value, key: name)
                    }
                }
            }
            //--
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in }))
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section("Соединение с устройством")
        <<< TextRow(){ $0.title = "Адрес:"; $0.value = Settings.shared.addr; $0.tag = "addr" }
        <<< TextRow(){ $0.title = "Логин:"; $0.value = Settings.shared.login; $0.tag = "login" }
        <<< PasswordRow(){ $0.title = "Пароль:"; $0.value = Settings.shared.pwd; $0.tag = "pwd" }
        <<< SwitchRow(){ $0.title = "Автообновление:"; $0.value = Settings.shared.autoRefresh; $0.tag = "autoRefresh" }
        <<< DecimalRow(){ $0.title = "Период обновления (сек):"; $0.value = Settings.shared.refreshPeriod; $0.tag = "refreshPeriod" }
    
        +++ Section("Идентификаторы оборудования")
        <<< TextRow(){ $0.title = "waterTrmId:"; $0.value = Settings.shared.waterTrmId; $0.tag = "waterTrmId" }
        <<< TextRow(){ $0.title = "heaterInTrmId:"; $0.value = Settings.shared.heaterInTrmId; $0.tag = "heaterInTrmId" }
        <<< TextRow(){ $0.title = "heaterOutTrmId:"; $0.value = Settings.shared.heaterOutTrmId; $0.tag = "heaterOutTrmId" }
        <<< TextRow(){ $0.title = "pumpRelayID:"; $0.value = Settings.shared.pumpRelayID; $0.tag = "pumpRelayID" }
        <<< TextRow(){ $0.title = "heaterRelayID:"; $0.value = Settings.shared.heaterRelayID; $0.tag = "heaterRelayID" }
        <<< TextRow(){ $0.title = "lightWaterRelayID:"; $0.value = Settings.shared.lightWaterRelayID; $0.tag = "lightWaterRelayID" }
        <<< TextRow(){ $0.title = "lightExtRelayID:"; $0.value = Settings.shared.lightExtRelayID; $0.tag = "lightExtRelayID" }
        <<< TextRow(){ $0.title = "heaterPrsID:"; $0.value = Settings.shared.heaterPrsID; $0.tag = "heaterPrsID" }
        <<< TextRow(){ $0.title = "filterPrsID:"; $0.value = Settings.shared.filterPrsID; $0.tag = "filterPrsID" }
        <<< TextRow(){ $0.title = "waterLevelID:"; $0.value = Settings.shared.waterLevelID; $0.tag = "waterLevelID" }
    
        +++ Section("Идентификаторы оборудования")
        <<< TextRow(){ $0.title = "Имя lightExt:"; $0.value = Settings.shared.lightExtName; $0.tag = "lightExtName" }
        
        +++ Section("")
        <<< ButtonRow(){ $0.title = "Записать"}.onCellSelection{ _,_ in self.saveSettings() }
        
    }
    
}
