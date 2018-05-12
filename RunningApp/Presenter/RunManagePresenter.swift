

import Foundation
import AVFoundation

protocol RunManagePresenterProtocol {
    init(view: RunManageViewProtocol)
    func getElapsedTime(startTimeDate: Date) -> String
    func getCurrentCalorieBurned(startTimeDate: Date) -> Double
    func checkCurrentSpeedIsPaceable(currentSpeed: Double, pace: Double) -> currentSpeedType
}

class RunManagePresenter: RunManagePresenterProtocol {

    private var view: RunManageViewProtocol!
    private var model: RunManageModelProtocol!

    required init(view: RunManageViewProtocol) {
        self.view = view
        self.model = RunManageModel()
    }

    /** 開始時間から現在の経過時間を返却
     * - return 現在の経過時間 / HH:mm:ss
     */
    func getElapsedTime(startTimeDate: Date) -> String {
        return model.getElapsedTime(startTimeDate: startTimeDate)
    }
    
    /** カロリー計算 */
    func getCurrentCalorieBurned(startTimeDate: Date) -> Double {
        return model.getCurrentCalorieBurned(startTimeDate: startTimeDate)
    }

    /** 現在のスピードと設定した理想のペースを比較する */
    func checkCurrentSpeedIsPaceable(currentSpeed: Double, pace: Double) -> currentSpeedType {
        return model.checkCurrentSpeedIsPaceable(currentSpeed: currentSpeed, pace: pace)
    }
    
}
