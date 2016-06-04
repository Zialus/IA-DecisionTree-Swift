all:
	swift build -Xcc -O
	mv ./.build/debug/DecisionTree .

clean:
	if [ -f ./DecisionTree ]; then rm ./DecisionTree; fi
	if [ -d ./.build/ ]; then rm -rf ./.build/; fi

test: testRestaurant

testIris:
	./DecisionTree Input/iris.csv fulldebug < Input/input_commands_iris.txt

testRestaurant:
	./DecisionTree Input/restaurant.csv fulldebug < Input/input_commands_restaurant.txt

testWeather:
	./DecisionTree Input/weather.csv fulldebug < Input/input_commands_weather.txt
