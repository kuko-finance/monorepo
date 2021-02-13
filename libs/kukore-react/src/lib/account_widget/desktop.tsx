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

const AccountWidgetContainer = styled(motion.div)`
  position: fixed;
  z-index: 2;
  right: ${(props) => props.theme.spacing.normal};
  top: ${(props) => props.theme.spacing.normal};
  min-width: 150px;
  padding: ${(props) => props.theme.spacing.normal};
  border-radius: ${(props) => props.theme.spacing.normal};
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

const Address = styled.span`
  font-family: 'Roboto Mono', monospace;
`;

const Cross = styled.span`
  color: ${(props) => props.theme.textColor};
  font-size: 25px;
`;

export const DesktopAccountWidget = () => {
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
      console.log('close');
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

  console.log(web3State.connected);
  console.log(web3State.account);

  return (
    <>
      <AccountWidgetContainer
        whileHover={{
          scale: web3State.connected ? 1 : 1.1,
        }}
        whileTap={{
          scale: web3State.connected ? 1 : 0.9,
        }}
        transition={{
          type: 'spring',
        }}
        variants={{
          shiftable: (i) => ({
            x: i,
          }),
        }}
        animate={'shiftable'}
        custom={web3State.connected ? -(50 + 12) : 0}
        onClick={onConnect}
        style={{
          cursor: web3State.connected ? 'auto' : 'pointer',
        }}
      >
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
            <Address>
              {web3State.account.slice(0, 6)}...
              {web3State.account.slice(web3State.account.length - 4)}
            </Address>
          </>
        ) : (
          <span>Connect wallet</span>
        )}
      </AccountWidgetContainer>
      {web3State.account !== null ? (
        <motion.div
          onClick={onClose}
          whileTap={{
            scale: 0.9,
          }}
          whileHover={{
            scale: 1.1,
          }}
          variants={{
            appearable: (i) => ({
              scale: i,
            }),
          }}
          transition={{
            type: 'spring',
          }}
          animate={'appearable'}
          custom={web3State.connected ? 1 : 0}
          style={{
            zIndex: 1,
            position: 'fixed',
            cursor: 'pointer',
            right: 16,
            top: 16,
            width: 50,
            height: 50,
            borderRadius: theme.radius.normal,
            backgroundColor: theme.primaryColor,
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
          }}
        >
          <Cross>✖</Cross>
        </motion.div>
      ) : null}
    </>
  );
};
