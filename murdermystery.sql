--Murder occurred Jan 15 2018, in SQL City.

SELECT *
FROM crime_scene_report
WHERE date = 20180115 AND type = 'murder' AND city = 'SQL City'
              
-- Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".

-- Witness 1

SELECT *
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
-- 14887, Morty Schapiro, 118009, 4919, Northwestern Dr, 111564949

-- Witness 2

SELECT *
FROM person
WHERE address_street_name = 'Franklin Ave' AND name LIKE 'Annabel%'
-- 16371, Annabel Miller, 490173, 103, Franklin Ave, 318771143

-- Witness 1 says: I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. 
-- The membership number on the bag started with "48Z". Only gold members have those bags. The man got into a car with a plate that included "H42W".

-- Witness 2 says: I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.

SELECT *
FROM get_fit_now_member
WHERE id LIKE '48Z%' AND membership_status = 'gold'
-- 2 options: id: 48Z7A, person_id: 28819, name: Joe Germuska OR id: 48Z55, person_id: 67318, name: Jeremy Bowers


SELECT *
FROM get_fit_now_check_in
WHERE check_in_date = 20180109 AND (membership_id = '48Z7A' OR membership_id = '48Z55')
-- Both worked out on that day! Joe Germuska checked in between 4pm and 5:30pm, Jeremy Bowers checked in between 3:30pm and 5pm

SELECT * 
FROM person
WHERE name = 'Joe Germuska' OR name = 'Jeremy Bowers'
-- Joe's Licence ID: 173289
-- Jeremy's Licence ID: 423327 

SELECT * 
FROM drivers_license
WHERE id = 173289 or id = 423327
-- Jeremy's plate number is 0H42W2 - no match
-- No records for Joe

SELECT * 
FROM facebook_event_checkin
WHERE person_id = 67318 or person_id = 28819

-- Additionally, Jeremy was at 'The Funky Grooves Tour' on the day of the murder.

-- There is only 1 plate that matches Witness 1's description, license id: 183779
SELECT * 
FROM person
WHERE license_id = 183779
-- id: 78193, name: Maxine Whitely, license_id: 183779, address_number: 110, street_name: fisk rd, ssn: 137882671

SELECT * 
FROM person
WHERE id = 67318 or id = 28819
-- Joe Germuska and Maxine Whitely are neighbours! Maxine 110 Fisk Road, Joe 111 Fisk Road
-- But, she does not have a membership 
-- According to Witness 1's testimony, the gunshot was heard in the gym then a man (Joe Germuska) ran out with his membership bag, and got into Maxine Whitely's car.
-- Let's keep digging.

SELECT * 
FROM interview
WHERE person_id = 67318 OR person_id = 28819 OR person_id = 78193
-- Jeremy Bowers says: I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
-- She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017. 

SELECT person_id, COUNT(event_name)
FROM facebook_event_checkin
WHERE event_name = 'SQL Symphony Concert' and date >= 20171200 and date <= 20171231
GROUP BY person_id
ORDER BY COUNT(event_name) DESC
-- 2 people attended the SQL  Symphony Concert 3 times in December 2017 - personid: 24556 or personid: 99716

SELECT *
FROM person
WHERE id = 24556 or id = 99716
-- id: 24556, name: bryan pardo, license_id: 101191, address_number: 703, street_name: machine ln, ssn: 816663882
-- id: 99716, name: miranda priestly, license_id: 202298, address_number: 1883, street_name: golden ave, ssn: 987756388

SELECT *
FROM drivers_license
WHERE id = 101191 or id = 202298
-- Miranda Priestly is 5'5, has red hair and drives a Tesla Model S
-- No record for Bryan Pardo

SELECT *
FROM income
WHERE ssn = 987756388
-- Her annual income is $310,000

-- So, our killer must be Miranda Priestly!

INSERT INTO solution VALUES (1, 'Miranda Priestly');
SELECT value FROM solution;

-- Congrats, you found the brains behind the murder! Everyone in SQL City hails you as the greatest SQL detective of all time. Time to break out the champagne!