import React, { useCallback, useState } from 'react';
import Web3 from 'web3';

export interface Web3State {
  web3: Web3;
  set: (st: Web3State) => void;
  networkId: number;
  account: string;
  connected: boolean;
}

const doNothing = () => null;

const initialState: Web3State = {
  web3: null,
  set: doNothing,
  networkId: null,
  account: null,
  connected: false,
};

export const Web3Context = React.createContext<Web3State>(initialState);

export const Web3ContextProvider: React.FC<React.PropsWithChildren<any>> = (
  props: React.PropsWithChildren<any>
): JSX.Element => {
  const [web3State, setWeb3State] = useState<Web3State>(initialState);

  return (
    <Web3Context.Provider
      value={{
        ...web3State,
        set: setWeb3State,
      }}
    >
      {props.children}
    </Web3Context.Provider>
  );
};
