all:
	swift build -Xcc -O
	mv ./.build/debug/DecisionTree .

clean:
	if [ -f ./DecisionTree ]; then rm ./DecisionTree; fi
	if [ -d ./.build/ ]; then rm -rf ./.build/; fi

test:
	./DecisionTree Input/restaurant.csv fulldebug < Input/input_commands.txt
