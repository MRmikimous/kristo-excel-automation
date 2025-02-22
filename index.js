import express from "express"
import { readConfig } from "./utils"

const config = await readConfig('config.ini')

const app = express()
app.listen(config.PORT)