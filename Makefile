DEBUGMODE = fulldebug
EXEC = DecisionTree

all:
	swift build -Xswiftc -O -Xswiftc -wmo -c release
	cp ./.build/release/$(EXEC) .

clean:
	swift package clean
	if [ -f ./$(EXEC) ]; then rm ./$(EXEC); fi

test: testWeather testIris

testIris:
	time ./DecisionTree Input/iris.csv $(DEBUGMODE) < Input/input_commands_iris.txt

testRestaurant:
	time ./DecisionTree Input/restaurant.csv $(DEBUGMODE) < Input/input_commands_restaurant.txt

testWeather:
	time ./DecisionTree Input/weather.csv $(DEBUGMODE) < Input/input_commands_weather.txt
