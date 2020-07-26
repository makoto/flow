import React, {useState} from "react"
import * as fcl from "@onflow/fcl"


export default function ScriptTwo() {
  const [data, setData] = useState(null)

  const runScript = async e => {
    e.preventDefault()
    const response = await fcl.send([
      fcl.script`
        pub struct SomeStruct {
          pub var x: Int
          pub var y: Int

          init(x: Int, y: Int) {
            self.x = x
            self.y = y
          }
        }

        pub fun main(): [SomeStruct] {
          return [SomeStruct(x: 1, y: 2), SomeStruct(x: 3, y: 4)]
        }
      `,
    ])
    setData(await fcl.decode(response))
  }

  return (
    <div>
      <div>Script Two</div>
      <button onClick={runScript}>Run Script</button>
      {data && <pre>{JSON.stringify(data, null, 2)}</pre>}
      <span>{data && data !== null && data[0].constructor.name} 1 </span>
      <span>{data && data !== null && data[1].constructor.name} 2 </span>
    </div>
  )
}