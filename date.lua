local textLabel = script.Parent

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

while true do
	local dateTable = os.date("*t")
	local day = getDayWithExtension(dateTable.day)

	local months = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}

	local weekdays = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}

	local weekday = weekdays[dateTable.wday]
	local month = months[dateTable.month]

	textLabel.Text = weekday .. ", " .. month .. " " .. day
	
	wait(86400)
end
