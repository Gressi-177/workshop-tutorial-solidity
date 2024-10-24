import { promises as fs } from "fs";

let config: any;

export async function initConfig() {
  console.log("Config initialized");
  config = JSON.parse((await fs.readFile("/config.json")).toString());
  return config;
}

export function getConfig() {
  return config;
}

export function setConfig(path: string, val: string) {
  const splitPath = path.split(".").reverse();
  let ref = config;
  while (splitPath.length > 1) {
    let key = splitPath.pop();
    if (key) {
      if (!ref[key]) {
        ref[key] = {};
      }
      ref = ref[key];
    } else {
      return;
    }
  }
}

export async function updateConfig() {
  return fs.writeFile("/config.json", JSON.stringify(config, null, 2));
}
