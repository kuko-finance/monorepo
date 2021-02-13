import Web3Modal from 'web3modal';
import WalletConnectProvider from '@walletconnect/web3-provider';
import Authereum from 'authereum';
import { KukoTheme } from '../theme';
import Web3 from 'web3';

export const getModal = (theme: KukoTheme): Web3Modal => {
  return new Web3Modal({
    network: 'mainnet',
    lightboxOpacity: 0.8,
    cacheProvider: true,
    disableInjectedProvider: false,
    providerOptions: {
      walletconnect: {
        package: WalletConnectProvider,
        options: {
          infuraId: '111b164861a94548b3c6f0f65235ea6e',
        },
      },
      authereum: {
        package: Authereum, // required
      },
    },
    theme: {
      background: theme.fallbackBackground,
      main: theme.textColor,
      secondary: theme.textColor,
      border: '#00000000',
      hover: theme.primaryColor,
    },
  });
};

export const onProvider = async (
  modal: Web3Modal,
  provider,
  setWeb3: (w3: Web3) => void,
  setAccount: (acc: string) => void,
  setNetworkId: (nid: number) => void,
  setConnected: (conn: boolean) => void
) => {
  const web3 = new Web3(provider);

  const accounts = await web3.eth.getAccounts();
  const network = await web3.eth.net.getId();
  let connected = false;

  setAccount(accounts[0]);
  setWeb3(web3);
  setNetworkId(network);
  setConnected(true);

  provider.on('accountsChanged', (accounts: string[]) => {
    console.log('accountsChanged', accounts);
    if (accounts.length === 0) {
      setConnected(false);
      setAccount(null);
      setWeb3(null);
      setNetworkId(null);
      modal.clearCachedProvider();
    } else {
      setAccount(accounts[0]);
      setConnected(true);
      console.log('icic');
      if (!connected) {
        modal.toggleModal();
      }
      connected = true;
    }
  });

  // Subscribe to chainId change
  provider.on('chainChanged', (chainId: number) => {
    console.log('chainChanged', chainId);
    setNetworkId(chainId);
  });

  provider.on('error', (err) => {
    console.error('error', err);
  });

  provider.on('close', () => {
    console.log('close');
  });

  provider.on('connect', () => {
    console.log('connect');
    connected = true;
    setConnected(true);
  });

  provider.on('disconnect', () => {
    console.log('disconnect');
    setConnected(false);
    connected = false;
    setAccount(null);
    setWeb3(null);
    setNetworkId(null);
    modal.clearCachedProvider();
  });
};
