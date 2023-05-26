//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Sunil Kumar Reddy Sanepalli on 26/05/23.
//

import XCTest
@testable import WeatherApp

final class WeatherAppTests: XCTestCase {

    let viewModel = WeatherViewModel()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWeatherData() {
        getWeatherDetails()
        
        //Weather Details
        XCTAssertNotNil(viewModel.weatherDetails)
        XCTAssertNotNil(viewModel.weatherDetails?.weather)
        XCTAssertNotNil(viewModel.weatherDetails?.name)
        
        //Location Name Details
        let locationName = viewModel.getLocationDetails()
        XCTAssertEqual(locationName, "Orlando, US")
        XCTAssertNotEqual(locationName, "US")
        
        //Date is available or not
        let formatDate = viewModel.getFormatDate()
        XCTAssertNotNil(formatDate)

        //Minimum Temperature
        let tempMin = viewModel.getTempMin()
        XCTAssertNotNil(tempMin)
        XCTAssertEqual(tempMin, "24")
        XCTAssertNotEqual(tempMin, "")

        //Feel Like info
        let feelLike = viewModel.getFeelLike()
        XCTAssertNotNil(feelLike)
        XCTAssertEqual(feelLike, "26")
        XCTAssertNotEqual(feelLike, "")

    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //@usage: Once rceive the mock data assign to that data to weatherDetails property in viewmodel
    func getWeatherDetails() {
        if let weatherData = readLocalJSONFile(forName: "DummyWeatherDetails") {
            viewModel.weatherDetails = parse(jsonData: weatherData)
        }
    }
    
    //@usage: return decodable data
    func parse(jsonData: Data) -> WeatherApp.WeatherDetailsModel? {
        do {
            let decodedData = try JSONDecoder().decode(WeatherDetailsModel.self, from: jsonData)
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    //@usage: get the json file data if given file name available
    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            guard let pathString = Bundle(for: type(of: self)).path(forResource: name, ofType: "json") else {
                return nil
            }
            let fileUrl = URL(fileURLWithPath: pathString)
            let data = try Data(contentsOf: fileUrl)
            return data
        } catch {
            print("error: \(error)")
        }
        return nil
    }

}
