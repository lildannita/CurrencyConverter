package com.dg.restapi;

import org.jetbrains.annotations.NotNull;
import org.springframework.boot.configurationprocessor.json.JSONException;
import org.springframework.web.bind.annotation.*;
import org.springframework.boot.configurationprocessor.json.JSONObject;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import org.apache.commons.io.IOUtils;
import org.xml.sax.SAXException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

@RestController
@RequestMapping(value = "/getData")
public class RestApiController {
    static class DataException extends Exception {
        public DataException(String message) {
            super(message);
        }
    }

    final private static String cbrJsonEncoding = "UTF-8";
    final private static String testUrl = "https://www.google.com";
    final private static String cbrDailyUrl = "https://www.cbr-xml-daily.ru/daily_json.js";
    final private static String cbrCodesUrl = "https://www.cbr.ru/scripts/XML_valFull.asp";
    private static String makeCurrencyPeriodUrl(Map<String, String> params) {
        String url = "https://www.cbr.ru/scripts/XML_dynamic.asp?";
        url += ("date_req1=" + params.get("left_date") + "&");
        url += ("date_req2=" + params.get("right_date") + "&");
        url += ("VAL_NM_RQ=" + params.get("valute"));
        System.out.println(url);
        return url;
    }

    private static void setRequestFields(@NotNull HashMap<String, Object> map) {
        map.put("Internet Connection", null);
        map.put("CBR Connection", null);
        map.put("Data Ready", null);
        map.put("Data", null);
    }
    private static void setInternetInfo(@NotNull HashMap<String, Object> map, boolean info) { map.put("Internet Connection", info); }
    private static void setCbrInfo(@NotNull HashMap<String, Object> map, boolean info) { map.put("CBR Connection", info); }
    private static void setDataInfo(@NotNull HashMap<String, Object> map, boolean info) { map.put("Data Ready", info); }

    private static boolean checkServerInternetConnection() throws IOException {
        URL url = new URL(testUrl);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("HEAD");

        return connection.getResponseCode() == HttpURLConnection.HTTP_OK;
    }

    private static HashMap<String, String> setBaseValute() {
        HashMap<String, String> baseMap = new HashMap<>();

        baseMap.put("Code", "RUB");
        baseMap.put("Name", "Российский рубль");
        baseMap.put("NameEng", "Russian ruble");
        baseMap.put("Symbol", Currency.getInstance("RUB").getSymbol());

        return baseMap;
    }

    private static Document getXmlObject(String url) throws ParserConfigurationException, IOException, SAXException {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        return db.parse(url);
    }

    private static JSONObject getJsonObject(String url) throws JSONException, IOException {
        return new JSONObject(IOUtils.toString(new URL(url), cbrJsonEncoding));
    }

    @GetMapping(value = "/valuteInfo")
    public Map<String, Object> getValuteInfo() {
        HashMap<String, Object> requestAnswer = new HashMap<>();
        setRequestFields(requestAnswer);

        try {
            setInternetInfo(requestAnswer, checkServerInternetConnection());

            JSONObject cbrJsonObject = getJsonObject(cbrDailyUrl);
            setCbrInfo(requestAnswer, true);
            List<String> valuteCodes = getOnlyDailyValuteId(cbrJsonObject);
            Document cbrXmlCodes = getXmlObject(cbrCodesUrl);

            requestAnswer.put("Data", parseXmlCodes(cbrXmlCodes, valuteCodes));
            requestAnswer.put("Base", setBaseValute());
            setDataInfo(requestAnswer, true);
        } catch (IOException err) {
            System.out.println(err.getMessage());
            setCbrInfo(requestAnswer, false);
        } catch (JSONException | DataException | ParserConfigurationException | SAXException err) {
            System.out.println(err.getMessage());
            setDataInfo(requestAnswer, false);
        }

        return requestAnswer;
    }

    private static List<String> getOnlyDailyValuteId(JSONObject jsonObject) throws DataException {
        List<String> dailyCodes = new ArrayList<>();

        try {
            JSONObject valuteJson = (JSONObject) jsonObject.get("Valute");
            Iterator valuteKeysIt = valuteJson.keys();
            while (valuteKeysIt.hasNext())
                dailyCodes.add((String) valuteKeysIt.next());
        } catch (JSONException err) {
            throw new DataException(err.getMessage());
        }

        return dailyCodes;
    }

    private static HashMap<String, HashMap<String, String>> parseXmlCodes(@NotNull Document doc, @NotNull List reqValute) {
        HashMap<String, HashMap<String, String>> data = new HashMap<>();
        NodeList codesList = doc.getElementsByTagName("Item");

        for (int i = 0; i < codesList.getLength(); i++) {
            Node nElement = codesList.item(i);
            if (nElement.getNodeType() == Node.ELEMENT_NODE) {
                Element element = (Element) nElement;
                String valuteCharCode = element.getElementsByTagName("ISO_Char_Code").item(0).getTextContent();
                if (reqValute.contains(valuteCharCode)) {
                    HashMap<String, String> info = new HashMap<>();
                    Currency valuteElement = Currency.getInstance(valuteCharCode);

                    info.put("ID", element.getAttribute("ID"));
                    info.put("Name", element.getElementsByTagName("Name").item(0).getTextContent());
                    info.put("EngName", element.getElementsByTagName("EngName").item(0).getTextContent());
                    info.put("Symbol", valuteElement.getSymbol());

                    data.put(valuteCharCode, info);
                }
            }
        }

        return data;
    }

    @GetMapping(value = "/lastExchangeRates")
    public Map<String, Object> getLastExchangeRates() {
        HashMap<String, Object> requestAnswer = new HashMap<>();
        setRequestFields(requestAnswer);

        try {
            setInternetInfo(requestAnswer, checkServerInternetConnection());

            JSONObject cbrJsonObject = getJsonObject(cbrDailyUrl);
            setCbrInfo(requestAnswer, true);

            requestAnswer.put("Data", parseJsonLastCurrency(cbrJsonObject));
            setDataInfo(requestAnswer, true);
        } catch (IOException err) {
            System.out.println(err.getMessage());
            setCbrInfo(requestAnswer, false);
        } catch (JSONException | DataException err) {
            System.out.println(err.getMessage());
            setDataInfo(requestAnswer, false);
        }

        return requestAnswer;
    }

    private static HashMap<String, HashMap<String, Object>> parseJsonLastCurrency(JSONObject jsonObject) throws DataException {
        HashMap<String, HashMap<String, Object>> data = new HashMap<>();
        List<String> wasteProperties = Arrays.asList("ID", "NumCode", "CharCode", "Nominal", "Name");

        HashMap<String, Object> baseProperties = new HashMap<>();
        baseProperties.put("Value", 1F);
        baseProperties.put("Previous", 1F);
        data.put("RUB", baseProperties);

        try {
            JSONObject valuteJson = (JSONObject) jsonObject.get("Valute");
            Iterator valuteKeysIt = valuteJson.keys();
            while (valuteKeysIt.hasNext()) {
                String valuteCode = (String) valuteKeysIt.next();
                Currency valuteElement = Currency.getInstance(valuteCode);
                JSONObject valuteCodeJson = (JSONObject) valuteJson.get(valuteCode);
                Iterator valuteCodeIt = valuteCodeJson.keys();
                HashMap<String, Object> valuteProperties = new HashMap<>();

                while (valuteCodeIt.hasNext()) {
                    String propertyName = (String) valuteCodeIt.next();
                    Object propertyValue = valuteCodeJson.get(propertyName);

                    if (propertyName.equals("Value") || propertyName.equals("Previous"))
                        propertyValue = (float) ((double) propertyValue / (int) valuteCodeJson.get("Nominal"));

                    if (!wasteProperties.contains(propertyName))
                        valuteProperties.put(propertyName, propertyValue);
                }

                data.put(valuteCode, valuteProperties);
            }
        } catch (JSONException err) {
            throw new DataException(err.getMessage());
        }

        return data;
    }

    @GetMapping(value = "/currencyPeriod")
    public Map<String, Object> getCurrencyPeriod(@RequestParam Map<String, String> params) {
        HashMap<String, Object> requestAnswer = new HashMap<>();
        setRequestFields(requestAnswer);

        try {
            setInternetInfo(requestAnswer, checkServerInternetConnection());

            String url = makeCurrencyPeriodUrl(params);
            Document cbrXmlCurrencyPeriod = getXmlObject(url);
            setCbrInfo(requestAnswer, true);

            requestAnswer.put("Data", parseXmlCurrencyPeriod(cbrXmlCurrencyPeriod));
            setDataInfo(requestAnswer, true);
        } catch (IOException err) {
            System.out.println(err.getMessage());
            setCbrInfo(requestAnswer, false);
        } catch (ParserConfigurationException | SAXException | ParseException | DataException err) {
            System.out.println(err.getMessage());
            setDataInfo(requestAnswer, false);
        }

        return requestAnswer;
    }

    private static HashMap<Date, Float> parseXmlCurrencyPeriod(Document doc) throws ParseException, DataException {
        HashMap<Date, Float> data = new HashMap<>();
        NodeList currencyPeriod = doc.getElementsByTagName("Record");

        SimpleDateFormat formatter = new SimpleDateFormat("dd.MM.yyyy", Locale.ENGLISH);

        for (int i = 0; i < currencyPeriod.getLength(); i++) {
            Node nElement = currencyPeriod.item(i);
            if (nElement.getNodeType() == Node.ELEMENT_NODE) {
                Element element = (Element) nElement;
                Date date = formatter.parse(element.getAttribute("Date"));
                Double value = Double.valueOf(element.getElementsByTagName("Value").item(0).getTextContent().replace(",", "."));
                Integer nominal = Integer.valueOf(element.getElementsByTagName("Nominal").item(0).getTextContent());
                if (nominal == 0)
                    throw new DataException("Data is not correct");
                data.put(date, (float) (value / nominal));
            }
            else {
                throw new DataException("URL is not correct");
            }
        }

        return data;
    }
}
