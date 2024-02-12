import re

INPUT_FILE = 'чеки.txt'
OUTPUT_FILE = 'чеки_по_папкам.txt'

SERVICE_MASK = r'_.*'
MONTH_MASK = r'_([а-яА-ЯёЁ]+)\.'


def open_file(file_name:str) -> list:
    '''
    Функция принимает на вход имя файла в формате txt.
    Возвращает его содержимое разделённое по строчкам в виде списка.
    '''
    receipt_list = []
    with open(file_name, mode='r', encoding='utf-8-sig') as file:
        receipt_list = [line[:-1] for line in file]
    print('Общее кол-во квитанций:', len(receipt_list))
    return receipt_list


def make_service_list(receipt_list:list) -> list:
    '''
    Функция принимает на вход список названий квитанций в формате pdf.
    Возвращает перечень предоставляемых услуг ЖКХ.
    '''
    service_list = []
    for receipt in receipt_list:
        service_name = re.sub(SERVICE_MASK, '', receipt)
        if service_name not in service_list:
            service_list.append(service_name)
    return service_list


def make_month_list(receipt_list:list) -> list:
    '''
    Функция принимает на вход список названий квитанций в формате pdf.
    Возвращает список месяцев в которые поступала оплата услуг ЖКХ.
    '''
    month_list = []
    for receipt in receipt_list:
        month_name = re.search(MONTH_MASK, receipt).group(1)
        if month_name not in month_list:
            month_list.append(month_name)
    return month_list


def main():
    '''
    '''
    receipt_list = open_file(INPUT_FILE)
    service_list = make_service_list(receipt_list)
    month_list = make_month_list(receipt_list)


if __name__ == "__main__":
    main()