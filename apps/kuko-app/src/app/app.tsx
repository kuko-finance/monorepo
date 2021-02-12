import React, { useEffect } from 'react';
import { createGlobalStyle } from 'styled-components';
import { Web3ReactProvider } from '@web3-react/core';
import { Web3Provider } from '@ethersproject/providers'
import Web3Modal from 'web3modal';
import WalletConnectProvider from "@walletconnect/web3-provider";
import * as KuiriLeagueV1 from '@kuko-finance/contracts/KuiriLeagueV1.json';

const GlobalStyle = createGlobalStyle`

  html, #root {
    width: 100%;
    height: 100%;
  }

  body {
    margin: 0;
    height: 100%;
    width: 100%;
  }
`;

export function App() {

  return <div>
    <p>LEL caca</p>
  <div
      style={{
        width: 100,
        height: 100,
        backgroundColor: 'red'
      }}
      onClick={() => {
        const modal = new Web3Modal({
          network: 'mainnet',
          cacheProvider: true,
          providerOptions: {
            walletconnect: {
              package: WalletConnectProvider,
              options: {
                infuraId: process.env.REACT_APP_INFURA_ID
              }
            },
          }
        });
        modal.connect()
          .then((pro) => {
            console.log('oui', pro);
          })

      }}
    />
  </div>
}

export default App;
