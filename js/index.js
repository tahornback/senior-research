import axios from 'axios';
import fastcsv from 'fast-csv';
import fs from 'fs';
import { readFile } from 'fs/promises';
// import covidTestingSites from '../arcgisCovidTestingLocations.json'

let writeStream = fs.createWriteStream('covidSites.csv')
let newObj = {features:[]}

const covidTestingSites = JSON.parse(await readFile(new URL('../arcgisCovidTestingLocations.json', import.meta.url)));

for(let i = 0; i < covidTestingSites.features.length; i++) {
    delete covidTestingSites.features[i].geometry;
    newObj.features[i]=covidTestingSites.features[i].attributes;
}

fastcsv  
.write(newObj.features, { headers: true })
.pipe(writeStream);

async function addPercentPopulation () {

    let writeStream = fs.createWriteStream('out.csv')
    let arr = []
    let totalPopulation = 0;

    await new Promise((resolve, reject) => fastcsv.parseFile('../data.csv', {headers: true})
        .on('error', error => console.error(error))
        .on('data', row => {
            row.pop = Number.parseInt(row.pop.replace(',',''));
            totalPopulation += row.pop;
            arr.push(row);
        })
        .on('end', rowCount => {
            console.log(`Parsed ${rowCount} rows`);
            resolve()
        }));

        let arr2 = []
        
    for(let i = 0; i < arr.length; i++) {
        let row = arr[i];

        row.popPercent = row.pop / totalPopulation;

        arr2.push(row)
    }

    console.log('All done!');


    console.log('arr2 size after gets', arr2.length)

    fastcsv  
        .write(arr2, { headers: true })
        .pipe(writeStream);
}

async function getLatLngOfZips () {
    let writeStream = fs.createWriteStream('out.csv')
    let arr = []

    await new Promise((resolve, reject) => fastcsv.parseFile('../data.csv', {headers: true})
        .on('error', error => console.error(error))
        .on('data', row => {
            arr.push(row);
        })
        .on('end', rowCount => {
            console.log(`Parsed ${rowCount} rows`);
            resolve()
        }));

    let arr2 = []

    console.log('arr', arr)
    console.log('arr size', arr.length)

    for(let i = 0; i < arr.length; i++) {
        let row = arr[i];
        const res = await axios.get(getUrlForZip(row.ZIP))
        const latLng = res.data.results[0].locations[0].latLng
        // console.log(latLng);
        row.lat = latLng.lat
        row.lng = latLng.lng
        arr2.push(row)
    }

    console.log('All done!');


    console.log('arr2 size after gets', arr2.length)

    fastcsv  
        .write(arr2, { headers: true })
        .pipe(writeStream);

    function getUrlForZip (zip) {
        return `https://www.mapquestapi.com/geocoding/v1/address?key=B0fnlAkTuZtNck4wD8wfAMqHRmYFVMGw&location=${zip},US`
    }
}