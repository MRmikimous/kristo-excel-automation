import { Service } from 'node-windows';
import path from "path";
const dir = path.join(process.cwd(), "index.js");

var svc = new Service({
  name: 'Kristo-Excel-Automation',
  description: 'Kristo Excel Automation',
  script: dir,
  env: {
    name: "NODE_ENV",
    value: "production"
  }
});

// Listen for the "install" event, which indicates the
// process is available as a service.
svc.on('install', function () {
  svc.start();
});

// Just in case this file is run twice.
svc.on('alreadyinstalled', function () {
  console.log('This service is already installed.');
});

// Listen for the "start" event and let us know when the
// process has actually started working.
svc.on('start', function () {
  console.log(svc.name + ' started!');
});

// Install the script as a service.
console.log("Installing to", dir)
svc.install();