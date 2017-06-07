DEBUGMODE = fulldebug

all:
	swift build -Xswiftc -O -c release
	mv ./.build/release/DecisionTree .

clean:
	swift package clean
	if [ -f ./DecisionTree ]; then rm ./DecisionTree; fi

test: testWeather testIris

testIris:
	./DecisionTree Input/iris.csv $(DEBUGMODE) < Input/input_commands_iris.txt

testRestaurant:
	./DecisionTree Input/restaurant.csv $(DEBUGMODE) < Input/input_commands_restaurant.txt

testWeather:
	./DecisionTree Input/weather.csv $(DEBUGMODE) < Input/input_commands_weather.txt
