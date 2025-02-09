import json


def main():
    with open('Billy_Milligan.json') as fp:
        data = json.load(fp)
        print(data)


if __name__ == '__main__':
    main()
