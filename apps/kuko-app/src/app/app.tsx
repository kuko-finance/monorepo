import React from 'react';
import { AccountWidget } from '@kuko-finance/kukore-react';
import { Web3ContextProvider } from '@kuko-finance/kukore-react';

export function App() {
  return (
    <>
      <Web3ContextProvider>
        <AccountWidget />
      </Web3ContextProvider>
    </>
  );
}

export default App;
