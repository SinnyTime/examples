-- The only part of this script involving AI is the determination of months/weekdays in different languages to save me time

local LocalizationService = game:GetService("LocalizationService")

-- Get references to the TextLabel or TextButton
local dateTextLabel = script.Parent
local timeTextLabel = script.Parent.Parent.Time

local function getDayWithExtension(day)
	local lastDigit = day % 10
	local extension = "th"

	if lastDigit == 1 and day ~= 11 then
		extension = "st"
	elseif lastDigit == 2 and day ~= 12 then
		extension = "nd"
	elseif lastDigit == 3 and day ~= 13 then
		extension = "rd"
	end

	return day .. extension
end

-- Multi-language support
local language = "EN"
local months = {

	EN = {
		"January",
		"February",
		"March",
		"April",
		"May",
		"June",
		"July",
		"August",
		"September",
		"October",
		"November",
		"December"
	},
	FR = {
		"Janvier",
		"Février",
		"Mars",
		"Avril",
		"Mai",
		"Juin",
		"Juillet",
		"Août",
		"Septembre",
		"Octobre",
		"Novembre",
		"Décembre"
	},
	DE = {
		"Januar",
		"Februar",
		"März",
		"April",
		"Mai",
		"Juni",
		"Juli",
		"August",
		"September",
		"Oktober",
		"November",
		"Dezember"
	},
	ES = {
		"Enero",
		"Febrero",
		"Marzo",
		"Abril",
		"Mayo",
		"Junio",
		"Julio",
		"Agosto",
		"Septiembre",
		"Octubre",
		"Noviembre",
		"Diciembre"
	},
	IT = {
		"Gennaio",
		"Febbraio",
		"Marzo",
		"Aprile",
		"Maggio",
		"Giugno",
		"Luglio",
		"Agosto",
		"Settembre",
		"Ottobre",
		"Novembre",
		"Dicembre"
	},
	PT = {
		"Janeiro",
		"Fevereiro",
		"Março",
		"Abril",
		"Maio",
		"Junho",
		"Julho",
		"Agosto",
		"Setembro",
		"Outubro",
		"Novembro",
		"Dezembro"
	},
	NL = {
		"Januari",
		"Februari",
		"Maart",
		"April",
		"Mei",
		"Juni",
		"Juli",
		"Augustus",
		"September",
		"Oktober",
		"November",
		"December"
	},
	RU = {
		"Январь",
		"Февраль",
		"Март",
		"Апрель",
		"Май",
		"Июнь",
		"Июль",
		"Август",
		"Сентябрь",
		"Октябрь",
		"Ноябрь",
		"Декабрь"
	},
	JP = {
		"1月",
		"2月",
		"3月",
		"4月",
		"5月",
		"6月",
		"7月",
		"8月",
		"9月",
		"10月",
		"11月",
		"12月"
	},
	ZH = {
		"一月",
		"二月",
		"三月",
		"四月",
		"五月",
		"六月",
		"七月",
		"八月",
		"九月",
		"十月",
		"十一月",
		"十二月"
	},
	KR = {
		"1월",
		"2월",
		"3월",
		"4월",
		"5월",
		"6월",
		"7월",
		"8월",
		"9월",
		"10월",
		"11월",
		"12월"
	},
	AR = {
		"يناير", "فبراير", "مارس", "أبريل", "مايو", "يونيو", "يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر"
	},
}

local weekdays = {
	EN = {
		"Sunday",
		"Monday",
		"Tuesday",
		"Wednesday",
		"Thursday",
		"Friday",
		"Saturday"
	},
	FR = {
		"Dimanche",
		"Lundi",
		"Mardi",
		"Mercredi",
		"Jeudi",
		"Vendredi",
		"Samedi"
	},
	DE = {
		"Sonntag",
		"Montag",
		"Dienstag",
		"Mittwoch",
		"Donnerstag",
		"Freitag",
		"Samstag"
	},
	ES = {
		"Domingo",
		"Lunes",
		"Martes",
		"Miércoles",
		"Jueves",
		"Viernes",
		"Sábado"
	},
	IT = {
		"Domenica",
		"Lunedì",
		"Martedì",
		"Mercoledì",
		"Giovedì",
		"Venerdì",
		"Sabato"
	},
	PT = {
		"Domingo",
		"Segunda-feira",
		"Terça-feira",
		"Quarta-feira",
		"Quinta-feira",
		"Sexta-feira",
		"Sábado"
	},
	NL = {
		"Zondag",
		"Maandag",
		"Dinsdag",
		"Woensdag",
		"Donderdag",
		"Vrijdag",
		"Zaterdag"
	},
	RU = {
		"Воскресенье",
		"Понедельник",
		"Вторник",
		"Среда",
		"Четверг",
		"Пятница",
		"Суббота"
	},
	JP = {
		"日曜日",
		"月曜日",
		"火曜日",
		"水曜日",
		"木曜日",
		"金曜日",
		"土曜日"
	},
	ZH = {
		"星期天",
		"星期一",
		"星期二",
		"星期三",
		"星期四",
		"星期五",
		"星期六"
	},
	KR = {
		"일요일",
		"월요일",
		"화요일",
		"수요일",
		"목요일",
		"금요일",
		"토요일"
	},
	AR = {"الأحد", "الاثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"},
}

-- Get the system language
local function getSystemLanguage()
	local localeId = LocalizationService.RobloxLocaleId
	local languageCode = localeId:sub(1,2):upper() -- Extract the language code from the Locale Id

	-- If the language code is not in our language table, default to English
	if not weekdays[languageCode] or not months[languageCode] then
		languageCode = "EN"
	end

	return languageCode
end

-- Check if the current year is a leap year
local function isLeapYear(year)
	return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)
end

-- Check if daylight saving time is in effect
local function isDaylightSavingTime(dateTable)
	local isDST = false

	if dateTable.month > 3 and dateTable.month < 11 then
		isDST = true
	elseif dateTable.month == 3 and dateTable.day > 7 then
		isDST = true
	elseif dateTable.month == 11 and dateTable.day < 7 then
		isDST = true
	end

	return isDST
end

-- This function will be used to get the formatted date
local function getFormattedDate()
	local dateTable = os.date("*t")
	local day = getDayWithExtension(dateTable.day)

	local weekday = weekdays[language][dateTable.wday]
	local month = months[language][dateTable.month]

	return weekday .. ", " .. month .. " " .. day
end

while true do
	-- Error handling
	local status, error = pcall(function()
		-- Get current time
		local currentTime = os.time()
		local dateTable = os.date("*t", currentTime)

		-- Detect the system language
		language = getSystemLanguage()

		-- Offset to convert UTC to EST (EST is UTC-5 but due to daylight saving it can be UTC-4)
		local offset = -5

		-- Adjust for daylight saving time
		if isDaylightSavingTime(dateTable) then
			offset = -4
		end

		-- Convert current time to seconds since midnight
		local secondsSinceMidnight = currentTime % 86400

		-- Adjust for time zone
		secondsSinceMidnight = secondsSinceMidnight + offset*3600

		-- If the result is negative, we went back to the previous day, so add 24 hours
		if secondsSinceMidnight < 0 then
			secondsSinceMidnight = secondsSinceMidnight + 86400
		end

		-- Calculate hours and minutes
		local hours = math.floor(secondsSinceMidnight / 3600)
		local minutes = math.floor((secondsSinceMidnight % 3600) / 60)

		-- Get formatted date
		local formattedDate = getFormattedDate()

		-- Update the TextLabels
		dateTextLabel.Text = formattedDate
		timeTextLabel.Text = string.format("%02d:%02d", hours, minutes)
	end)

	if not status then
		warn("An error occurred: " .. error)
	end

	-- Wait for 1 second before the loop repeats
	wait(1)
end
