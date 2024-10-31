# System imports
import sys
import os
# Selenium imports
import selenium
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains

# Extending the paths from the application scope
sys.path.append(os.path.join(os.getcwd(), '.'))
sys.path.append(os.path.join(os.getcwd(), '..'))
sys.path.append(os.path.join(os.getcwd(), '..','src'))
# application imports
import src.PythonCodes.DataManage_common
import src.PythonCodes.utils.messageHandler

class Bots_Selenium:
    def __init__(self, c, m):
        self.rc = 0
        self.c = c
        self.m = m
        self.url_yahoo_finance = "https://finance.yahoo.com"
        self.url_python = "http://www.python.org"
        self.url_selenium = "https://www.selenium.dev/selenium/web/web-form.html"
        self.url_MolRefAnt_App = "http://127.0.0.1:8000/MolRefAnt_App/"
        self.url_MolRefAnt_App_interogation = "http://127.0.0.1:8000/interrogation/"
    def testing_firefox(self):
        rc = 0

        driver = webdriver.Firefox()
        driver.get(self.url_python)
        assert "Python" in driver.title
        elem = driver.find_element(By.NAME, "q")
        elem.clear()
        elem.send_keys("pycon")
        elem.send_keys(Keys.RETURN)
        assert "No results found." not in driver.page_source
        driver.close()

        return rc

    def selenium_insert_into_website(self, mz_I_Rel, mz_I_Rel_sorted):
        rc = self.c.get_RC_SUCCESS()
        driver = webdriver.Firefox()
        driver.get(self.url_MolRefAnt_App_interogation)
        textarea_box = driver.find_element(by=By.NAME, value="spectrum")
        # Printing to the TexttArea
        for i in range(len(mz_I_Rel_sorted[:])):
            msg = ""
            for j in range(len(mz_I_Rel_sorted[i][:])):
                msg += str('{0:>14.5f}'.format(float(mz_I_Rel_sorted[i][j])))
            # [end-loop] :03.2f 0:<22
            textarea_box.send_keys(msg+"\n")

        return rc

    def testing_MolRefAnt_App(self):
        rc = 0
        driver = webdriver.Firefox()
        #driver.get(self.url_MolRefAnt_App)
        driver.get(self.url_MolRefAnt_App_interogation)
        #text_box = driver.find_element(by=By.NAME, value="mainForm:mainAccordion:parentIon")
        #text_box.send_keys("Hello parent Ion!!")

        #textarea_box = driver.find_element(by=By.NAME, value="mainform:fragtextarea")
        # <textarea name="spectrum" cols="50" rows="35" required="" id="id_spectrum"></textarea>
        textarea_box = driver.find_element(by=By.NAME, value="spectrum")

        spectrum_lst = []
        spectrum_lst.append(["mz rel: 0000", [723.14404296875, 100.0]])
        spectrum_lst.append(["mz rel: 0001", [80.35002899169922, 3.961404728942086]])
        spectrum_lst.append(["mz rel: 0002", [80.34484100341797, 1.6972800768468088]])
        spectrum_lst.append(["mz rel: 0003", [237.33436584472656, 1.221643124837757]])
        spectrum_lst.append(["mz rel: 0004", [392.6870422363281, 1.0368571144414533]])
        spectrum_lst.append(["mz rel: 0005", [170.19068908691406, 0.918763583266478]])
        spectrum_lst.append(["mz rel: 0006", [73.2267074584961, 0.9170511261995674]])
        spectrum_lst.append(["mz rel: 0007", [162.09967041015625, 0.916330328043111]])
        spectrum_lst.append(["mz rel: 0008", [114.33312225341797, 0.8542209026106744]])
        spectrum_lst.append(["mz rel: 0009", [54.2354850769043, 0.8530500694090934]])
        spectrum_lst.append(["mz rel: 0010", [63.44682312011719, 0.8265969137668722]])
        spectrum_lst.append(["mz rel: 0011", [215.04322814941406, 0.8204325370107883]])
        spectrum_lst.append(["mz rel: 0012", [77.9862060546875, 0.7611538212714906]])


        print("cmd: "+self.c.getInsert_into_web_Marker()+"="+self.c.getInsert_into_web())


        for i in range(len(spectrum_lst[:])):
            textarea_box.send_keys(str(spectrum_lst[i])+"\n")

        print("spectrum_lst = [] ---->: ", spectrum_lst[:])

        #driver.quit()

        return rc
    def testing_selenium(self):
        rc = 0
        driver = selenium.webdriver.Chrome()
        driver.get(self.url_selenium)
        title = driver.title
        driver.implicitly_wait(0.5)

        # <div class="row">
        # <div class="col-md-4 py-2">
        # <label class="form-label w-100">Text input
        # <input type="text" class="form-control" name="my-text" id="my-text-id" myprop="myvalue">
        text_box = driver.find_element(by=By.NAME, value="my-text")
        submit_button = driver.find_element(by=By.CSS_SELECTOR, value="button")

        text_box.send_keys("Selenium")
        submit_button.click()

        message = driver.find_element(by=By.ID, value="message")
        text = message.text
        assert text == "Received!"
        print("Text message ", text)

        driver.quit()

        return rc
    def testing_yahoo_search(self):
        rc = 0
        driver = webdriver.Firefox()
        #driver = selenium.webdriver.Firefox()
        driver.get(self.url_yahoo_finance)
        title = driver.title
        driver.implicitly_wait(0.5)

        find_element_button = driver.find_element(by=By.NAME, value="agree")
        submit_button = driver.find_element(by=By.CSS_SELECTOR, value="button")
        #submit_button.click()


        '''
        text_box = driver.find_element(by=By.ID, value="ybar-sbq")
        submit_button = driver.find_element(by=By.CSS_SELECTOR, value="button")

        text_box.send_keys("yahoo finance")
        submit_button.click()

        message = driver.find_element(by=By.ID, value="message")
        text = message.text
        print("Return from the search ", text)
        '''

        return rc
