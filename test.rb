require 'active_record'
require 'sqlite3'
require 'csv'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './pcs2.db'
  )

class Outs < ActiveRecord::Base
    CSV.foreach('./final.csv') do |row|
      find_or_create_by(code: "#{row[0]}") do |pc|
      pc.lat = row[1]
      pc.long = row[2]
    end
  end
end



# begin
#   # db = SQLite3::Database.open "pcs.db"
#   # db.execute "CREATE TABLE IF NOT EXISTS OutcodeShort(Id INTEGER PRIMARY KEY,
#   # Name TEXT, Lat TEXT, Long TEXT)"
#   CSV.foreach('out.csv') do |row|
#     find_or_create_by(code: "#{row[1]}") do |pc|
#     pc.Lat = row[2]
#     pc.Long = row[3]
#   end
# end

# rescue SQLite3::Exception => e
#   puts "Exception occurred"
#   puts e
# ensure
#   db.close if db
# end

# CREATE TABLE outs (
# 	id INTEGER PRIMARY KEY,
# 	code VARCHAR(8) NOT NULL,
# 	lat VARCHAR(15) NOT NULL,
# 	long VARCHAR(15) NOT NULL
# );


# const puppeteer = require('puppeteer');
# // const prompt = require('prompt');

# // prompt.start();

# const kody = {
#   heathrow: 'tw6',
#   gatwick: 'rh6',
#   'city airport': 'e16',
#   paddington: 'w2',
#   stansted: 'cm24',
#   luton: 'lu1',
#   coventgarden: 'wc2h'
# }

# const accounts = {
#   artur: {
#     login: '12357',
#     password: 'Password1'
#   },
#   adam: {
#     login: '12747',
#     password: 'Albert12'
#   },
#   justyna: {
#     login: '27489',
#     password: 'Tinusia11'
#   }
# }

# async function takeBooking() {
#   const browser = await puppeteer.launch({ headless: false, defaultViewport: null});
#   const page = await browser.newPage();
#   await page.setDefaultNavigationTimeout(0)
#   await page.setViewport({ width: 1200, height: 1540 })
#   await waitForLogin()
#   await openBrowser(page)
#   await logIn(page)
#   await page.$x("//div[@class='desktop']/span[contains(., 'DASHBOARD')]");
#   await waitForPrebooks()
#   await scanPrebooksAndChooseJob(page)
#   await page.close()
#   await browser.close()

# }

# async function scanPrebooksAndChooseJob(page) {
#   await page.goto('https://www.addleedrivers.co.uk/drp/driver/prebook')
#   await page.waitForSelector('.table__cell-value-inner', { visible: true })
#   await scanTable(page)
#   await page.waitForTimeout(30000 + (Math.random(1000) * 30 ))
#   await scanPrebooksAndChooseJob(page)
#   await page.waitForTimeout(200)
#   const jobsNotYetOffered = await page.$x("//div[@class='notifications__progress']/span[contains(., 'offered')]");
#   if (jobsNotYetOffered) {
#     await page.waitForTimeout(200)
#     await scanPrebooksAndChooseJob(page)
#   }
# }

# async function openBrowser(page) {
#   await page.goto('https://www.addleedrivers.co.uk/drp/driver/sign-in#/driver/login');
#   // const credentials = await new Promise((resolve, reject) => {
#   //   prompt.get(['username', 'password'], (error, result) => {
#   //     resolve(result);
#   //   });
#   // });

#   // const username = credentials.username;
#   // const password = credentials.password;
# }

# async function waitForPrebooks() {
#   return new Promise((resolve) => {
#     console.log('waiting for prebooks');
#     let result = function checkTime() {
#       let prebookTime = getPrebookTime()[0]
#       let currentTime = getPrebookTime()[1]
#        if ((( currentTime.getHours() == prebookTime.hour ) && (currentTime.getMinutes() < prebookTime.minute)) || (( currentTime.getHours() == prebookTime.hour ) && (currentTime.getMinutes() == prebookTime.minute)  && (currentTime.getSeconds() < prebookTime.second))) {
#         console.log('Prebooks today at: ' + prebookTime.hour + ' : ' + prebookTime.minute);
#         console.log(currentTime.getHours() + ':' + currentTime.getMinutes() + ':' + currentTime.getSeconds());
#       } else {
#         console.log('Prebooks loaded')
#         clearInterval(timeCheck)
#         resolve()
#       }
#     }
#     let timeCheck =  setInterval(result, 1000)
#     return
#   })
# }

# async function waitForLogin() {
#   return new Promise((resolve) => {
#     console.log('waiting to Log In');
#     let result = function checkTime() {
#       let currentTime = new Date()
#       let logInTime = {}

#       // WEEKDAYS
#       if (currentTime.getDay() == 1 || currentTime.getDay() == 2 || currentTime.getDay() == 3 || currentTime.getDay() == 4) {
#         if (currentTime.getHours() == 18 && currentTime.getMinutes() <= 30) {
#           logInTime.hour = 18,
#           logInTime.minute = 26
#         }
#         else if ((currentTime.getHours() == 12) && ( currentTime.getMinutes() <= 30 )) {
#           logInTime.hour = 12,
#           logInTime.minute = 26,
#           logInTime.logOut = 18
#         }
#       }

#       // FRIDAY
#       else if ( currentTime.getDay() == 5 ) {
#         if ( currentTime.getHours() == 19) {
#           logInTime.hour = 19,
#           logInTime.minute = 56
#         }
#         else if ((currentTime.getHours() == 12) && ( currentTime.getMinutes() <= 30 )) {
#           logInTime.hour = 12,
#           logInTime.minute = 26,
#           logInTime.logOut = 18
#         }
#       }

#       //SATURDAY
#       if ( currentTime.getDay() == 6 ) {
#           logInTime.hour = 19,
#           logInTime.minute = 56
#       }

#       // SUNDAY
#       else if ( currentTime.getDay() == 0 ) {
#         logInTime.hour = 18,
#         logInTime.minute = 16,
#         logInTime.logOut = 0
#       }

#       if ((currentTime.getHours() == logInTime.hour) && (currentTime.getMinutes() < logInTime.minute)) {
#         console.log('Will log in at: ' + logInTime.hour + ' : ' + logInTime.minute);
#         console.log(currentTime.getHours() + ':' + currentTime.getMinutes() + ':' + currentTime.getSeconds());
#       } else {
#         console.log('Logging in')
#         clearInterval(timeCheck)
#         resolve()
#       }
#     }
#     let timeCheck =  setInterval(result, 1000)
#     return
#   })
# }

# function getPrebookTime() {
#   let currentTime = new Date()
#   let prebookTime = {}
#   // WEEKDAYS
#   if (currentTime.getDay() == 1 || currentTime.getDay() == 2 || currentTime.getDay() == 3 || currentTime.getDay() == 4) {
#     if (currentTime.getHours() == 18 && currentTime.getMinutes() <= 30) {
#       prebookTime.hour = 18,
#       prebookTime.minute = 29,
#       prebookTime.second = 40
#     }
#     else if (currentTime.getHours() == 12 && ( currentTime.getMinutes() <= 30 )) {
#       prebookTime.hour = 12,
#       prebookTime.minute = 29,
#       prebookTime.second = 58,
#       prebookTime.logOut = 18
#     }
#   }
#   // FRIDAY
#   else if ( currentTime.getDay() == 5 ) {
#     if ( currentTime.getHours() == 19 ) {
#       prebookTime.hour = 19,
#       prebookTime.minute = 59,
#       prebookTime.second = 40
#     }
#     else if ((currentTime.getHours() == 12) && ( currentTime.getMinutes() <= 30 )) {
#       prebookTime.hour = 12,
#       prebookTime.minute = 29,
#       prebookTime.second = 55
#       prebookTime.logOut = 18
#     }
#   }
#   //SATURDAY
#   else if ( currentTime.getDay() == 6 ) {
#     if ( currentTime.getHours() == 19 ) {
#       prebookTime.hour = 19,
#       prebookTime.minute = 59,
#       prebookTime.second = 40
#     }
#   }
#   // SUNDAY
#   else if ( currentTime.getDay() == 0 ) {
#     if (currentTime.getHours() == 18 && currentTime.getMinutes() <= 20) {
#       prebookTime.hour = 18,
#       prebookTime.minute = 19,
#       prebookTime.second = 40,
#       prebookTime.logOut = 0
#     }
#   }
#   return [prebookTime, currentTime]
# }

# async function logIn(page) {
#   const login = await page.waitForSelector('input[placeholder="PL Number"]', { visible: true })
#   await login.type(`12357`, { delay: 100 });
#   const pass = await page.waitForSelector('input[placeholder="Password"]')
#   await pass.type(`Password1`, { delay: 100});
#   await page.click('button[type="submit"]')
#   await page.waitForSelector('.dashboard', { visible: true })
#   // reLogInIfNotLoggedIn()
# }

# async function scanTable(page) {
#   await page.waitForTimeout(1000)
#   const tabelki = await page.$$('.table__tbody')
#   let jobCount = 0
#   let rowCount = tabelki.length
#   console.log(rowCount);
#   let bestJob = []
#   let start = Date.now()
#   let listOfJobs = []
#   let timeRange = ['4:00', '20:00']
#   let minimumDistance = 30
#   let londonMinDist = 50
#   // let start = Date.now()
#   for (let index = 0; index < tabelki.length; index++) {
#     jobCount += 1
#     let booking = {}
#     let job = [tabelki[index], await page.evaluate(el => el.innerText, tabelki[index])]

#     listOfJobs.push(job)
#     let lines = job[1].split('\n')
#     booking.time = lines[0]
#     booking.Type = lines[7] === '6 SEATER' ? 'MPV' : 'ST'
#     booking.pick = extractPostcode(lines[2])
#     booking.drop = extractPostcode(lines[3])
#     // console.log(booking);

#     await fillBooking(booking, bestJob, minimumDistance, londonMinDist)

#     if (jobCount == rowCount) {
#       let end = Date.now()
#       let time = end - start
#       console.log(`time:  ${time} ms `)
#       console.log(new Date().getSeconds(), new Date().getMilliseconds());
#       console.log(bestJob);
#       if (bestJob.length > 0) {
#         function getKeyByValue(object, value) {
#           return Object.keys(object).find(key => object[key] === value);
#         }
#         let postcodeChecker = function(el) {
#           Object.values(kody).includes(el) ? getKeyByValue(kody, `${el}`) : el
#         }
#         let best = await pickAJob(bestJob, londonMinDist, timeRange)
#         if (best) {
#           let bestJobElement = (listOfJobs.find(el => el[1].includes(`${best.pick}`, postcodeChecker(best.drop))))[0]
#           const elementLocation = bestJobElement.boundingBox().then(e => console.log(e))
#           // const rect = await page.evaluate((bestJobElement) => {
#           //   const {top, left, bottom, right} = bestJobElement.getBoundingClientRect();
#           //   return {top, left, bottom, right};
#           // }, bestJobElement);
#           // console.log(rect);
#               // browser.executeScript('arguments[0].scrollIntoView({ block: "center" })', bestJobElement.getWebElement())
#           // let jobButton = await bestJobElement.$('.button')
#           // await browser.wait(EC.elementToBeClickable(jobButton), 5000)
#           // jobButton.click()


#           // await $('.prebook-allocation-confirm__confirm').click()
#           // await $('.prebook-another-allocation-confirm__confirm').click()
#           // browser.sleep(60000)
#         }
#       }
#     }
#   }
# }

# function extractPostcode(line) {
#   const match = Object.keys(kody).find(key => String(line).toLowerCase().includes(key))
#   if (match) {
#     return kody[match].toUpperCase()
#   } else {
#     let code = line.split(',').at(-1).trim()
#     let checkedCode =  (code.length > 4) ? code.slice(0, -4) : code
#     return Number.isInteger(Number(checkedCode.at(-1))) ? checkedCode : checkedCode.substring(0, checkedCode.length - 1)
#   }
# }


# // function reLogInIfNotLoggedIn() {
# //   if (await page.$x("//div[@class='notifications__notification_warning'][contains(., '12:30')]"))
# //   if (await browser.element(by.cssContainingText('.prebook__notifications', 'offered')).isPresent()) {
# //     await browser.sleep(200 + Math.random() * 100)
# //     await scanPrebooksAndChooseJob()
# //   } else if (await browser.element(by.css('[placeholder = "Password"]')).isPresent()) {
# //     await browser.sleep(200 + Math.random(500))
# //     console.log('Prebooks loaded');
# //     await fillLoginForm()
# //     await browser.sleep(1000 + Math.random(1000) * 8)
# //     await scanPrebooksAndChooseJob()
# //   } else if (await browser.element(by.cssContainingText('.desktop', 'NEWS')).isPresent()) {
# //     await browser.element(by.cssContainingText('.button', 'Okay, I have watched this and understood it')).click()
# //     await browser.sleep(200 + Math.random(500))
# //     await scanPrebooksAndChooseJob()
# //   } else if (await browser.element(by.cssContainingText('.no-data', 'No jobs found')).isPresent()) {
# //     await browser.sleep(40000 + Math.random(500))
# //     await scanPrebooksAndChooseJob()
# //   } else if (await browser.element(by.cssContainingText('.notifications', 'You can allocate one more')).isPresent()) {
# //     await browser.sleep(40000 + Math.random(500))
# //     await scanPrebooksAndChooseJob()
# //   }
# //   // else if (await browser.element(by.cssContainingText('.notifications__notification_info', 'You can allocate one more.')).isPresent()) {
# //   //   await browser.sleep(200 + Math.random(500))
# //   //   await findASecondJob()
# //   // }
# //   else {
# //     await browser.wait(EC.presenceOf($('.prebook__address')), 50000)
# //     await findAJob()
# //     // currentTime.getHours() != logOutTime ?
# //     await scanPrebooksAndChooseJob()
# //     //  : logOut()
# //   }
# // }
# async function fillBooking(booking, bestJob, minimumDistance) {
#   if (booking.pick == booking.drop) {
#     return
#   }
#   let distance
#   let dbChecked = await checkDb(booking.pick, booking.drop)
#   if (dbChecked.constructor == Number ) {
#     distance = dbChecked
#   } else {
#   let kordy = await getCoords(booking.pick, booking.drop)
#   distance = await measureDistance(kordy)
#   }
#   await filterJobs(distance, booking, bestJob, minimumDistance)
# }

# function checkDb(pick, drop) {
#   return new Promise((resolve) => {
#     const sqlite3 = require('sqlite3').verbose();
#     let db = new sqlite3.Database('./pcs.db');
#     let sql = `SELECT dist FROM distances WHERE
#     (up ="${pick}" AND off="${drop}") OR
#     (up ="${drop}" AND off="${pick}")`
#     db.get(sql, [], (error, row) => {
#       if (row) {
#         resolve(row.dist)
#       } else {
#         resolve(pick, drop);
#       }
#     })
#     db.close()
#   })
# }

# function getCoords(postcode1, postcode2) {
#   const sqlite3 = require('sqlite3').verbose();
#   return new Promise((resolve) => {
#     let db = new sqlite3.Database('./pcs.db');
#     let sql = `SELECT code, long, lat FROM outs WHERE code="${postcode1}" OR code="${postcode2}";`

#     db.all(sql, [], (err, rows) => {
#       let innerCoords = [];
#       rows.forEach(row => innerCoords.push(parseFloat(row.lat), parseFloat(row.long), row.code));
#       resolve(innerCoords);
#     });
#     db.close();
#   })
# }

# async function measureDistance(data) {
#   if (!data[2] || !data[5]) { return 10 }
#   const https = require('https')
#   const sqlite3 = require('sqlite3').verbose();
#   let db = new sqlite3.Database('./pcs.db');


#   return new Promise((resolve) => {
#     let url = `https://api.tomtom.com/routing/1/calculateRoute/${Math.round(data[0] * 100) /100}%2C${Math.round(data[1] * 100) /100}%3A${Math.round(data[3] * 100) /100}%2C${Math.round(data[4] * 100) /100}/json?routeType=shortest&avoid=unpavedRoads&key=uwbU08nKLNQTyNrOrrQs5SsRXtdm4CXM  `
#     https.get(url, res => {
#       let body = '';

#       res.on('data', chunk => {
#         body += chunk;
#       });

#       res.on("end", () => {

#         try {
#           console.log('data w bazie ...' + data[2]  + ' ' + data[5]);
#           let json = JSON.parse(body);
#           let distanceInMiles = Math.round(json.routes[0].summary.lengthInMeters / 1600);
#           resolve((db.run(`INSERT INTO distances (up, off, dist) VALUES ("${data[2]}", "${data[5]}", "${Math.round(distanceInMiles)}");`)) && distanceInMiles)
#           db.close();
#         } catch (error) {
#           console.log('error found and caught - resolving 10');
#           resolve(10)
#           console.error(error.message);
#         };
#       }).on("error", (error) => {
#         console.log('error found and caught - resolving 10');
#         resolve(10)
#         console.error(error.message);
#       });
#     })
#   })
# }

# async function filterJobs(distance, booking, bestJob, minimumDistance) {
#   if (distance >= `${minimumDistance}`) {
#     booking.Type == 'ST' ? booking.v = distance : booking.v = Math.round(distance * 1.2)
#     await updateBestJob(bestJob, booking)
#       // execSync(`espeak -s 140 "${distance} miles from ${booking[0]} to ${booking[1]} at ${booking[2]}"`)
#   }
# }

# async function updateBestJob(best, job) {
#   const bannedPostcodes = ['CM', 'IG', 'RM', 'SS']

#   let containsBannedPostcode = await function(job) {
#     return bannedPostcodes.some(code => job.pick.includes(code))
#   }

#   if (!containsBannedPostcode(job)) {
#     if (best.length < 8 ) {
#       await best.push(job)
#       await best.sort((a, b) => (parseInt(a.v) > parseInt(b.v)) ? -1 : 1)
#     } else {
#       await best.sort((a, b) => (parseInt(a.v) > parseInt(b.v)) ? -1 : 1)
#       await parseInt(job.v) < (parseInt(best[2].v)) ? best[2] : (best[7] = job)
#       await best.sort((a, b) => (parseInt(a.v) > parseInt(b.v)) ? -1 : 1)
#     }
#   } else {
#     return
#   }
# }


# async function pickAJob(bestJob, londonMinDist, timeRange, startTime) {
# const codePriority = {
#   closeToHome: [
#     'ME1', 'ME2', 'ME4', 'ME5', 'ME6', 'ME7', 'ME8', 'ME9',
#     'ME10', 'ME11', 'ME12', 'ME13', 'ME14', 'ME15', 'ME16',
#     'ME17', 'ME18', 'ME19', 'ME20', 'TN1', 'TN11', 'TN9',
#     'TN10', 'TN12', 'TN13', 'TN14', 'TN15', 'TN18', 'TN23',
#     'TN24', 'TN25', 'TN26', 'TN27'],
#   farFromHomeOutsideLondon: [
#     'CT1', 'CT2', 'CT3', 'CT4', 'CT5', 'CT6', 'CT7', 'CT8',
#     'CT9', 'CT10', 'CT11', 'CT12', 'CT13', 'CT14', 'CT15',
#     'CT16', 'CT17', 'CT18', 'CT19', 'CT20', 'CT21', 'TN28',
#     'TN30', 'TN29', 'RH1', 'RH2', 'RH3', 'RH4', 'RH5', 'RH6',
#     'RH7', 'RH8', 'RH9', 'RH10', 'RH11', 'RH12', 'RH13', 'RH14',
#     'RH15', 'RH16', 'RH17', 'RH18', 'RH19', 'RH20'
#   ]
# }

# let hasPriority = (job) => {
#   if (Object.values(codePriority)[0].includes(job.pick)) {
#     return Object.keys(codePriority)[0]
#   } else if (Object.values(codePriority)[1].includes(job.pick)) {
#     return Object.keys(codePriority)[1]
#   } else {
#     return 'isALondonJob'
#   }
# }

# let isWithinTimeRange = await function(job) {
#   return job.time > timeRange[0] && job.time < timeRange[1]
# }

# let job = await bestJob.sort((a, b) => (parseInt(a.v) > parseInt(b.v)) ? -1 : 1)
# if (( job[0].v > 40 ) && ( hasPriority(job[0] ) == 'closeToHome' ))
#   { console.log(`best job  ${job[0].pick} to ${job[0].drop} - ${job[0].v} miles`)
#   // execSync(`afplay /System/Library/Sounds/Funk.aiff\n say Job from ${job[0].pick} to ${job[0].drop} at ${job[0].time} - ${job[0].v} miles`)  
#     return job[0] }
# // if (
# //   ( job[0].v > 120 ) && ( hasPriority(job[0] ) == 'closeToHome' ) ||
# //   (job[0] && isWithinTimeRange(job[0]) && ( hasPriority(job[0] ) == 'closeToHome' )) ||
# //   (job[0] && isWithinTimeRange(job[0]) && ( hasPriority(job[0] ) == 'farFromHomeOutsideLondon' ) && job[0].v > 1.3*job[1].v && ( hasPriority(job[1] ) == 'closeToHome' ) && isWithinTimeRange(job[1])) ||
# //   (job[0] && !isWithinTimeRange(job[0]) && ( hasPriority(job[0] ) == 'closeToHome' )) ||
# //   (job[0] && !isWithinTimeRange(job[0]) && ( !hasPriority(job[0] ) == 'closeToHome' )) && ( job[0].v > 70 ) ||
# //   (job[0] && !isWithinTimeRange(job[0]) && ( !hasPriority(job[0] ) == 'isALondonJob' ) && job[0].v > londonMinDist) ||
# //   (job[0] && !isWithinTimeRange(job[0]) && ( hasPriority(job[0] ) == 'isALondonJob' ) && job[0].v > londonMinDist)
# //   )
# //   { console.log(`best job  ${job[0].pick} to ${job[0].drop} - ${job[0].v} miles`)
# //   execSync(`afplay /System/Library/Sounds/Funk.aiff\n say Job from ${job[0].pick} to ${job[0].drop} at ${job[0].time} - ${job[0].v} miles`)  
# //   console.log(Date.now() + 'job1');
# //     return job[0]
# // } else if (
# //   (job[1] && job[2] && isWithinTimeRange(job[1]) && ( hasPriority(job[1] ) == 'closeToHome' ) && (job[1].v > job[2].v)) ||
# //   (job[1] && job[2] && isWithinTimeRange(job[1]) && ( hasPriority(job[1] ) == 'farFromHomeOutsideLondon' ) && (job[1].v > job[2].v)) ||
# //   (job[0] && job[1] && !isWithinTimeRange(job[1]) && ( !hasPriority(job[1] ) == 'isALondonJob' ) && job[0].v > londonMinDist) ||
# //   (job[0] && job[1] && !isWithinTimeRange(job[1]) && ( hasPriority(job[1] ) == 'isALondonJob' ) && job[0].v > londonMinDist))
# //   { console.log(`best job  ${job[1].pick} to ${job[1].drop} ${job[1].v} miles`)
# //   console.log(Date.now() + 'job2');

# //   return job[1]
# // } else if (
# //   (job[2] && isWithinTimeRange(job[2]) && ( hasPriority(job[2] ) == 'closeToHome' )) ||
# //   (job[2] && isWithinTimeRange(job[2]) && ( hasPriority(job[2] ) == 'farFromHomeOutsideLondon' )) ||
# //   (job[2] && !isWithinTimeRange(job[2]) && ( !hasPriority(job[2] ) == 'isALondonJob' ) && job[2].v > londonMinDist) ||
# //   (job[1] && job[2] && !isWithinTimeRange(job[1]) && ( hasPriority(job[1] ) == 'isALondonJob' ) && job[2].v > londonMinDist))
# //   { console.log(`best job  ${job[1].pick} to ${job[1].drop} ${job[1].v} miles`)
# //   console.log(Date.now() + 'job3');

# //     return job[2]
# // }
# }
# takeBooking()