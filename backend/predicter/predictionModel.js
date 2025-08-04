import { spawn } from 'child_process'
import path from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const pythonScript = path.join(__dirname, 'model.py')
const pythonPath = process.env.PYTHON_PATH || 'python'

export function getModelPrediction(filePath, razza) {
    razza = razza.toLowerCase()
    return new Promise((resolve, reject) => {
        const pyProcess = spawn(pythonPath, [pythonScript, filePath, razza])

        let output = ''
        let errorOutput = ''

        pyProcess.stdout.on('data', (data) => {
            output += data.toString()
        });

        pyProcess.stderr.on('data', (data) => {
            errorOutput += data.toString()
        });

        pyProcess.on('close', (code) => {
            if (code !== 0) {
                return reject(new Error(errorOutput || `Python process exited with code ${code}`))
            }

            try {
                const jsonLine = output
                    .split('\n')
                    .map(line => line.trim())
                    .find(line => {
                        try {
                            JSON.parse(line)
                            return true
                        } catch {
                            return false
                        }
                    });

                if (!jsonLine) {
                    throw new Error('No valid JSON found in Python output')
                }

                const result = JSON.parse(jsonLine)
                resolve(result)

            } catch (err) {
                reject(new Error('Invalid JSON output from Python'))
            }
        });
    });
}
