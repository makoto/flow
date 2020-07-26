import React, {useState} from "react"
import * as fcl from "@onflow/fcl"

export default function ScriptOne() {
  const [data, setData] = useState(null)

  const runScript = async e => {
    e.preventDefault()
    const response = await fcl.send([
      fcl.script`
        pub fun main(): Int {
          return 42 + 6
        }
      `,
    ])
    setData(await fcl.decode(response))
  }

  return (
    <div>
      <div>Script One</div>
      <button onClick={runScript}>Run Script</button>
      {data && <pre>{JSON.stringify(data, null, 2)}</pre>}
    </div>
  )
}