//
//  ViewController.swift
//  WeatherApp
//
//  Created by Александра Самсонова on 27.03.2021.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet var table: UITableView!
    var models = [DailyWeatherEntry]()
    var hourlyModels = [HourlyWeatherEntry]()

    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var current: CurrentWeather?

    override func viewDidLoad() {
        super.viewDidLoad()

        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)

        table.delegate = self
        table.dataSource = self

        table.backgroundColor = UIColor(red: 232/255.0, green: 237/255.0, blue: 255/255.0, alpha: 1.0)
        view.backgroundColor = UIColor(red: 232/255.0, green: 237/255.0, blue: 255/255.0, alpha: 1.0)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }

    // Getting location of user
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil  {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }

    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        
        // Getting coordinates of user
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude

        // Applying coordinates to make API-request
        let url = "https://api.darksky.net/forecast/ddcc4ebb2a7c9930b90d9e59bda0ba7a/\(lat),\(long)?exclude=[flags,minutely]"
        print(url)

        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in

            // Validation
            guard let data = data, error == nil else {
                print("Произошла ошибка, попробуйте еще раз")
                return
            }

            // Decoding JSON
            var json: WeatherResponse?
            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            }
            catch {
                print("Ошибка: \(error)")
            }

            guard let result = json else {
                return
            }

            let entries = result.daily.data
            print(entries)

            self.models.append(contentsOf: entries)

            let current = result.currently
            self.current = current

            self.hourlyModels = result.hourly.data

            // Updating interface according to received information
            DispatchQueue.main.async {
                self.table.reloadData()

                self.table.tableHeaderView = self.createTableHeader()
            }
        }).resume()
    }

   // Working with interface
    func createTableHeader() -> UIView {
        let headerVIew = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))

        headerVIew.backgroundColor = UIColor(red: 232/255.0, green: 237/255.0, blue: 255/255.0, alpha: 1.0)

        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerVIew.frame.size.height/5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height, width: view.frame.size.width-20, height: headerVIew.frame.size.height/5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height+summaryLabel.frame.size.height, width: view.frame.size.width-20, height: headerVIew.frame.size.height/2))

        headerVIew.addSubview(locationLabel)
        headerVIew.addSubview(tempLabel)
        headerVIew.addSubview(summaryLabel)

        tempLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center

        locationLabel.text = "Текущее местоположение"
        locationLabel.font = UIFont(name: "Helvetica", size: 20)

        guard let currentWeather = self.current else {
            return UIView()
        }

        tempLabel.text = String(format: "%.0f°C", ((currentWeather.temperature-32)*(5/9)))
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 35)
        summaryLabel.text = self.current?.summary
        summaryLabel.font = UIFont(name: "Helvetica", size: 35)
        return headerVIew
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // 1 cell that is collectiontableviewcell
            return 1
        }
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            cell.backgroundColor = UIColor(red: 232/255.0, green: 237/255.0, blue: 255/255.0, alpha: 1.0)
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        cell.backgroundColor = UIColor(red: 232/255.0, green: 237/255.0, blue: 255/255.0, alpha: 1.0)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// Structs to store data, only those variables that we need
struct WeatherResponse: Codable {
    let latitude: Float
    let longitude: Float
    let timezone: String
    let currently: CurrentWeather
    let hourly: HourlyWeather
    let daily: DailyWeather
    let offset: Float
}

struct CurrentWeather: Codable {
    let time: Int
    let summary: String
    let icon: String
    let temperature: Double
}

struct DailyWeather: Codable {
    let summary: String
    let icon: String
    let data: [DailyWeatherEntry]
}

struct DailyWeatherEntry: Codable {
    let time: Int
    let summary: String
    let icon: String
    let temperatureMin: Double
    let temperatureMax: Double
}

struct HourlyWeather: Codable {
    let summary: String
    let icon: String
    let data: [HourlyWeatherEntry]
}

struct HourlyWeatherEntry: Codable {
    let time: Int
    let summary: String
    let icon: String
    let temperature: Double
}
