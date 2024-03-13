/tool netwatch
add down-script="tool fetch url=\"TELEGRAM_API_KEY\
    TOKEN/sendMessage\?chat_id=-CHAT_ID=NAME_HOST\
    \_DOWN\" dst-path=telegram.txt" host=IP_HOST interval=20s type=\
    simple up-script="tool fetch url=\"https://api.telegram.org/botTELEGRAM_DOT_ID:\
    TOKEN/sendMessage\?chat_id=-CHAT_ID&text=\
    NOTE\" dst-path=telegram.txt"