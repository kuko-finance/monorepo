import React, { useCallback, useContext, useEffect, useState } from 'react';
import styled from '../styled';
import { KukoTheme } from '../theme';
import { motion } from 'framer-motion';
import { getModal, onProvider } from './logics';
import { useTheme } from 'styled-components';
import { Web3Context } from './context';
import Web3 from 'web3';
import makeBlockie from 'ethereum-blockies-base64';

const glassmo = (theme: KukoTheme) => `
  background-color: ${theme.fallbackBackground};
  @supports ((-webkit-backdrop-filter: blur(${theme.defaultBlur})) or (backdrop-filter: blur(${theme.defaultBlur}))) {
    background-color: ${theme.blurBackground};
    backdrop-filter: blur(${theme.defaultBlur});
  }
`;

const MobileWidgetContainer = styled.div`
  position: fixed;
  right: 0;
  bottom: 0;
  width: 100%;
  padding: ${(props) => props.theme.spacing.normal};
  padding-bottom: calc(12px + env(safe-area-inset-bottom));
  display: flex;
  justify-content: center;
  align-items: center;
  ${(props) => glassmo(props.theme)}
`;

const BlockiesImage = styled(motion.img)`
  z-index: 2;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  position: absolute;
`;

const BlockiesPlaceholder = styled.div`
  z-index: 1;
  width: 20px;
  height: 20px;
  background-color: #00000033;
  border-radius: 50%;
  position: absolute;
`;

const Address = styled(motion.span)`
  font-family: 'Roboto Mono', monospace;
`;

const Connect = styled(motion.span)``;

const Cross = styled.span`
  color: ${(props) => props.theme.textColor};
  font-size: 20px;
`;

export const MobileAccountWidget = () => {
  const theme = useTheme() as KukoTheme;
  const [modal] = useState(getModal(theme));
  const [cachedProvider, setCachedProvider] = useState(modal.cachedProvider);
  const web3State = useContext(Web3Context);
  const [clicked, setClicked] = useState(false);
  const [autoloaded, setAutoLoaded] = useState(false);
  const [web3, setWeb3] = useState<Web3>(null);
  const [networkId, setNetworkId] = useState<number>(null);
  const [account, setAccount] = useState<string>(null);
  const [connected, setConnected] = useState<boolean>(false);
  const [provider, setProvider] = useState(null);

  const onConnect = useCallback(async () => {
    const provider = await modal.connect();
    onProvider(
      modal,
      provider,
      setWeb3,
      setAccount,
      setNetworkId,
      setConnected
    );
    setProvider(provider);
    setClicked(true);
  }, [modal]);

  const onClose = useCallback(
    async (e) => {
      e.stopPropagation();
      modal.clearCachedProvider();
      setCachedProvider(null);
      if (provider && provider.disconnect) {
        await provider.disconnect();
      }
      setNetworkId(null);
      setAccount(null);
      setConnected(false);
      setWeb3(null);
      setProvider(null);
    },
    [modal, provider, web3State]
  );

  useEffect(() => {
    if (cachedProvider && !clicked && !autoloaded) {
      setAutoLoaded(true);
      modal
        .connect()
        .then((pro) => {
          onProvider(
            modal,
            pro,
            setWeb3,
            setAccount,
            setNetworkId,
            setConnected
          );
          setProvider(pro);
        })
        .catch(() => {
          modal.clearCachedProvider();
        });
    }
  }, [modal, autoloaded, clicked, cachedProvider]);

  useEffect(() => {
    web3State.set({
      set: web3State.set,
      web3,
      networkId,
      account,
      connected,
    });
  }, [web3, networkId, account, connected]);

  return (
    <MobileWidgetContainer onClick={onConnect}>
      {web3State.account !== null ? (
        <>
          <div
            style={{
              width: 20,
              height: 20,
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              marginRight: 12,
            }}
          >
            <BlockiesImage
              src={makeBlockie(web3State.account)}
              initial={{
                scale: 0,
              }}
              animate={{
                scale: 1,
                transition: {
                  delay: 1,
                  duration: 1,
                  type: 'spring',
                },
              }}
            />
            <BlockiesPlaceholder />
          </div>
          <Address
            whileTap={{
              scale: 0.9,
            }}
          >
            {web3State.account.slice(0, 6)}...
            {web3State.account.slice(web3State.account.length - 4)}
          </Address>
        </>
      ) : (
        <Connect
          whileTap={{
            scale: 0.9,
          }}
        >
          Connect wallet
        </Connect>
      )}
      {web3State.account !== null ? (
        <motion.div
          onClick={onClose}
          whileTap={{
            scale: 0.9,
          }}
          style={{
            position: 'absolute',
            right: 12,
            bottom: 9,
            width: 30,
            height: 30,
            borderRadius: '50%',
            backgroundColor: theme.primaryColor,
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
          }}
        >
          <Cross>✖</Cross>
        </motion.div>
      ) : null}
    </MobileWidgetContainer>
  );
};
