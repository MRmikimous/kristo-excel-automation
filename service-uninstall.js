import { Service } from 'node-windows';
import path from "path";

// Create a new service object
var svc = new Service({
  name: 'Hello World',
  script: path.join(process.cwd(), "index.js")
});

// Listen for the "uninstall" event so we know when it's done.
svc.on('uninstall', function () {
  console.log('Uninstall complete.');
  console.log('The service exists: ', svc.exists);
});

// Uninstall the service.
svc.uninstall();