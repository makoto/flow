import React from 'react';
import logo from './logo.svg';
import './App.css';
import CurrentUser from "./CurrentUser"
import ScriptOne from "./ScriptOne"
import ScriptTwo from "./ScriptTwo"
import TransactionOne from "./TransactionOne"

import * as fcl from "@onflow/fcl";
fcl.config()
  .put("challenge.handshake", "http://localhost:8701/flow/authenticate")

function App() {
  return (
    <div className="App">
      <CurrentUser/>
      <ScriptOne/>
      <ScriptTwo/>
      <TransactionOne />

      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header>
    </div>
  );
}

export default App;
