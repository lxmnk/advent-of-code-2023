class Symbol:
    def __init__(self, x, y, is_gear) -> None:
        self.x = x
        self.y = y
        self.is_gear = is_gear
    def __str__(self) -> str:
        return f"{self.x} | {self.y}"


class Number:
    def __init__(self, x, y, value) -> None:
        self.x = x
        self.y = y 
        self.value = int(value)
        self.length = len(value)
    def __str__(self) -> str:
        return f"{self.x} | {self.y} | {self.value}"
      
def parsing (symbols, numbers):
    with open("input.txt", "r") as file:
        result = 0
        running_number = ""
        for y,line in enumerate(file):
            for x,item in enumerate(line):
                if item.isdigit():
                    running_number = running_number + item
                elif item != "." and item != "\n":
                    symbols.append(Symbol(x,y, item == "*"))
                if not item.isdigit() and running_number != "":
                    numbers.append(Number(x-len(running_number), y, running_number))
                    running_number = ""

def solve_part_2(symbols, numbers):
    result = 0 
    for symbol in symbols:
        if symbol.is_gear:
            numbers_array = []
            for number in numbers:
                if (number.x-1 <= symbol.x  <= number.x + number.length and 
                                number.y-1 <= symbol.y <= number.y + 1):
                    numbers_array.append(number.value)
            if len(numbers_array) == 2:
                result += numbers_array[0] * numbers_array[1]
    print(f"part2 {result}")
    input("continue")

def solve_part_1(symbols, numbers):
    result = 0
    for number in numbers:
        for symbol in symbols:
            if (number.x-1 <= symbol.x  <= number.x + number.length and 
                            number.y-1 <= symbol.y <= number.y + 1):
                result += number.value
                break
            
    print(f"part 1 {result}")
    input("continue")

def main():
    symbols = []
    numbers = []
    parsing (symbols, numbers)
    solve_part_1(symbols, numbers)
    # solve_part_2(symbols, numbers)
    
if __name__ == "__main__":
    main()
