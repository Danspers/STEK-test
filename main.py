INPUT_FILE = 'чеки.txt'
OUTPUT_FILE = 'чеки_по_папкам.txt'


def open_file(file_name:str) -> list:
    '''
    Функция принимает на вход имя файла в формате txt.
    Возвращает его содержимое разделённое по строчкам в виде списка.
    '''
    file_list = []
    with open(file_name, mode='r', encoding='utf-8-sig') as file:
        file_list = [line[:-1] for line in file]
    return file_list

def main():
    '''
    '''
    receipt_list = open_file(INPUT_FILE)

    print(receipt_list[:5])


if __name__ == "__main__":
    main()