//
//  GlobalEnums.swift
//  Training
//
//  Created by Bryan on 9/20/16.
//  Copyright © 2016 Bryan Lloyd Anderson. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

public enum CanvassError: Error {
    case noInteractionTypesInCollectionView
    case failedToIntializeInteractionsFromAPI
}

public enum CellIdentifier: String {
    case feedCell
}

public enum SegueIdentifier: String {
    case feedToVideo
}

extension Notification.Name {
    public static let reloadedOffice = Notification.Name("reloaded-office")
    public static let updatedArea = Notification.Name("updated-area")
    public static let officeEditing = Notification.Name("office-editing")
    public static let homeUpdated = Notification.Name("home-updated")
    public static let customerUpdated = Notification.Name("customer-updated")
    public static let employeeSet = Notification.Name("employee-set")
    public static let tokenSet = Notification.Name("token-set")
    public static let noteUploaded = Notification.Name("note-uploaded")
    public static let interactionTypesSet = Notification.Name("interaction-types-set")
    public static let leadFieldsSet = Notification.Name("lead-fields-set")
    public static let fileDownloaded = Notification.Name("file-downloaded")
    public static let dateRangeChanged = Notification.Name("date-range-changed")
    public static let customDateRangeSelected = Notification.Name("custom_date_range_selected")
    public static let scrollingChildDismissed = Notification.Name("scrolling-child-dismissed")
    public static let searchSettingsSet = Notification.Name("search-settings-set")
    public static let cancelSearchOptions = Notification.Name("cancel-search-options")
    public static let zendeskSupportUpdated = Notification.Name("zendesk-support-updated")
    public static let dateRangeFinishedLoading = Notification.Name("date-range-finished-loading")
    public static let dateRangeOfficeStatsLoading = Notification.Name("date-range-office-stats-loading")
    public static let urlJWTTokenReceived = Notification.Name("url-jwt-token-received")
    public static let newLoginSet = Notification.Name("new-login-set")
    public static let currentCustomerUpdated = Notification.Name("current-customer-updated")
    public static let appointmentCreated = Notification.Name("appointment-created")
    public static let shouldUpdatePlannerDay = Notification.Name("should-update-planner-day")
    public static let locationPermissionStatusUpdated = Notification.Name("location-permission-status-updated")
    public static let addressStatusUpdated = Notification.Name("address-status-updated")
}

public enum UserDefaultsKey: String {
    case onboardingProcess
    case currentEmployee
    case currentLogin
    case authToken = "token"
    case employeeID = "employee_id"
    case isAdmin = "is_admin"
    
    case currentLat
    case currentLng
    
    case clientAuthJSON
    case integrationTypes
    
    case mapType
    
    case primaryCalendarIdentifier = "PrimaryCalendarIdentifier"
    case selectedOfficeIDs = "selected_office_ids"
    case username
    case rawSettingsData
    
    case lastAuthType
    case lastEnvironmentType
    case customStartDate
    case customEndDate
    case dateLastDisplayedCreateAddressHint
    
    case savedSearches
    case recentSearches
    
    case plannerDateSummary
        
    case homeCardSelectedTypes
}

public enum ExternalURLType: String {
    case playlist
}



public extension UserDefaults {
    
    func set(_ value: Any?, for key: UserDefaultsKey) {
        set(value, forKey: key.rawValue)
    }
    
    func value(for key: UserDefaultsKey) -> Any? {
        return object(forKey: key.rawValue)
    }
}




public enum Day: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var name: String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        }
    }
}

public enum TimeOfDay {
    case morning
    case afternoon
    case evening
}



public enum ReminderSearchParam {
    case allReminders
    case futureReminders
    case pastReminders
}

public enum AppointmentSearchParam {
    case allAppts
    case futureAppts
    case pastAppts
}



