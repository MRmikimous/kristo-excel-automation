import { writeFile, readFile } from 'node:fs/promises'
import { stringify, parse } from 'ini'

export async function readConfig(path) {
  let text = await readFile(path, {
    encoding: 'utf-8'
  })

  return parse(text)
}

export async function writeConfig(path, config) {
  text = stringify(config)

  await writeFile(path, text)
}