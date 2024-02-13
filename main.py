import re
import calendar
import locale
import pandas as pd

# Установка русской локализации для календаря
locale.setlocale(locale.LC_TIME, 'ru_RU')

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
        receipt_list = [line[:-1].lower() for line in file]
    print('Общее количество квитанций:', len(receipt_list))
    return receipt_list


def make_service_list(receipt_list:list) -> list:
    '''
    Функция принимает на вход список названий квитанций в формате pdf.
    Возвращает перечень предоставляемых услуг ЖКХ.
    '''
    service_list = []
    for receipt in receipt_list:
        service_name = re.sub(SERVICE_MASK, '', receipt).lower()
        if service_name not in service_list:
            service_list.append(service_name)
    print(f'Перечень услуг: {service_list} ({len(service_list)}шт.)')
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


def write_file(file_name:str, service_list:list, month_list:list, df:pd.DataFrame) -> None:
    '''
    Функция принимает на вход имя файла в формате txt и записывает в него данные.
    '''
    with open(file_name, mode='w', encoding='utf-8-sig') as file:
        total_delays = []
        for month in month_list:
            monthly_delay = []
            for service in service_list:
                try:
                    receipt = df.loc[(month, service), 'receipt']
                    print('/'+ month +'/'+ receipt, file=file)
                except:
                    monthly_delay.append(service)
            total_delays.append(monthly_delay)
        
        print('\nНе оплачены:', file=file)
        for delay, month in zip(total_delays, month_list):
            if delay:
                print(f'{month}:', file=file)
                for service in delay:
                    print(service, file=file)
        
    print(f'Квитанции рассортированы. Результат сортировки в файле: "{file_name}"')


def main():
    '''
    '''
    receipt_list = open_file(INPUT_FILE)
    service_list = make_service_list(receipt_list)
    month_list = [calendar.month_name[i].lower() for i in range(1, 13)]

    df = pd.DataFrame({'receipt':receipt_list})
    df['service'] = [re.sub(SERVICE_MASK, '', receipt).lower() for receipt in receipt_list]
    df['month'] = [re.search(MONTH_MASK, receipt).group(1) for receipt in receipt_list]
    df['month'] = pd.Categorical(df['month'], month_list)
    df.sort_values(by=['month', 'service'], inplace=True)
    df.set_index(['month', 'service'], inplace=True)
    del receipt_list
    
    write_file(OUTPUT_FILE, service_list, month_list, df)


if __name__ == "__main__":
    main()