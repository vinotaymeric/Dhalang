'use strict';

const createPdf = async() => {
    const url = process.argv[2]
    const temp_save_file_path = process.argv[3]
    const puppeteer_directory = process.argv[4]
    module.paths.push(puppeteer_directory);
    const puppeteer = require('puppeteer');
    let browser;
    try {
        browser = await puppeteer.launch({args: ['--no-sandbox', '--disable-setuid-sandbox']});
        const page = await browser.newPage();
        await page.goto(url, {timeout: 10000, waitUntil: 'networkidle2'});
        await page.waitFor(250);
        await page.pdf({
            path: temp_save_file_path,
            format: 'A4',
            margin: { top: 36, right: 36, bottom: 20, left: 36 },
            printBackground: true
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