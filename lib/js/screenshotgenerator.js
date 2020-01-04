'use strict';

const createPdf = async() => {
    const url =  process.argv[2]
    const temp_save_file_path = process.argv[3]
    const puppeteer_directory = process.argv[4]
    const temp_save_file_type = process.argv[5]
    module.paths.push(puppeteer_directory);
    const puppeteer = require('puppeteer');
    let browser;
    try {
        browser = await puppeteer.launch({args: ['--no-sandbox', '--disable-setuid-sandbox']});
        const page = await browser.newPage();
        await page.goto(url, {timeout: 10000, waitUntil: 'networkidle2'});
        await page.waitFor(250);
        await page.screenshot({
            path: temp_save_file_path,
            type: temp_save_file_type,
            fullPage: true
        });
    } catch (err) {
        console.log(err.message);
    } finally {
        if (browser) {
            browser.close();
        }
        process.exit();
    }
};
createPdf();