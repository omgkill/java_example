#!/usr/bin/python


#
# with open('m.txt', encoding='utf-8') as file_obj:
#     for line in file_obj:
#         print(line)


#
# with open('m.txt', encoding='utf-8') as file_obj:
#     contents = file_obj.read()
#     # contents = contents.rstrip()
#     # con_arr = contents.strip('\n')
#     for a  in contents:
#         print(a)
#         print('-----------')

with open('m.txt', encoding='utf-8') as file_obj:
    while True:
        line = file_obj.readline()
        if not line:
            break
        str = line.rstrip().lstrip()



#
# import pandas as pd
#
#
# # 获取文件的内容
# def get_contends(path):
#     with open(path) as file_object:
#         contends = file_object.read()
#     return contends
#
#
# # 将一行内容变成数组
# def get_contends_arr(contends):
#     contends_arr_new = []
#     contends_arr = str(contends).split(']')
#     for i in range(len(contends_arr)):
#         if (contends_arr[i].__contains__('[')):
#             index = contends_arr[i].rfind('[')
#             temp_str = contends_arr[i][index + 1:]
#             if temp_str.__contains__('"'):
#                 contends_arr_new.append(temp_str.replace('"', ''))
#             # print(index)
#         # print(contends_arr[i])
#     return contends_arr_new
#
#
# if __name__ == '__main__':
#     path = 'event.txt'
#     contends = get_contends(path)
#     contends_arr = get_contends_arr(contends)
#     contents = []
#     for content in contends_arr:
#         contents.append(content.split(','))
#     df = pd.DataFrame(contents, columns=['shelf_code', 'robotid', 'event', 'time'])
#     print(df)