# Fuzzing pdfbox
### Подготовка окружения
Собираем docker образ:
```
docker build --tag=pdfbox_workshop_img .
```
Запускаем контейнер:
```
docker run -it -v "$(pwd)/artifacts:/home/fuzz/artifacts:ro" \ --name=pdfbox_fuzz pdfbox_workshop_img
```
Применяем патч:
```
cd /home/fuzz/pdfbox
git apply ../artifacts/pdfbox.patch
```

### Подготовка корпуса
Подготавливаем входной корпус:
```
mkdir pdfbox/src/test/resources/org/apache/pdfbox/pdfparser/PDFStreamParserTestInputs
cp /home/fuzz/artifacts/corpus/* pdfbox/src/test/resources/org/apache/pdfbox/pdfparser/PDFStreamParserTestInputs
```
Собираем тесты и запускаем фаззинг FuzzTestPDFParser:
```
mvn test-compile
cd /home/fuzz/pdfbox/pdfbox
JAZZER_FUZZ=1 mvn test -Dtest=PDFStreamParserTest#FuzzTestPDFParser
```
Наработанный корпус хранится в `/home/fuzz/pdfbox/pdfbox/.cifuzz-corpus/`

### Фаззинг java кода с помощью jazzer

Собираем pdfbox:
```
cd /home/fuzz/pdfbox && mvn clean install
```
Cобираем обёртку для pdfbox:
```
mkdir fuzz && cd fuzz
cp -r /home/fuzz/artifacts/* .
javac -cp ../pdfbox/target/classes/ ./PDFStreamParserFuzzer.java
```
Запускаем фаззинг PDF парсера:
```
jazzer --cp=.:../pdfbox/target/classes/:../io/target/classes/:/home/fuzz/log4j/log4j-api-2.24.3.jar --target_class=PDFStreamParserFuzzer -dict=pdf.dict -close_fd_mask=3 -- corpus
```

### Сбор покрытия
Прогоняем наработанный корпус:
```
cd /home/fuzz/pdfbox/fuzz
jazzer --cp=.:../pdfbox/target/classes/:../io/target/classes/:/home/fuzz/log4j/log4j-api-2.24.3.jar --target_class=PDFStreamParserFuzzer -dict=pdf.dict -close_fd_mask=3 --coverage_dump=coverage.exec -runs=1 -- corpus
```
Генерируем html отчёт с помощью jacococli:
```
java -jar /home/fuzz/jacoco/lib/jacococli.jar report --classfiles ../pdfbox/target/pdfbox-3.0.4.jar --html report --sourcefiles ../pdfbox/src/main/java/
```
Копируем папку с html отчётом на хост:
```
docker cp pdfbox_fuzz:/home/fuzz/pdfbox/fuzz/report .
```