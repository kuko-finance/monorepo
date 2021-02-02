import React, { useEffect, useState } from 'react';
import styled, { createGlobalStyle } from 'styled-components';
// eslint-disable-next-line @typescript-eslint/no-var-requires
const isValidEmail = require('is-valid-email');


const StyledApp = styled.div`
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #ffe0e0;
  flex-direction: column;
`;

const Kuko = styled.span`
  font-size: 60px;
`;

const KukoDesc = styled.p`
  margin: 30px;
  width: 500px;
  max-width: 80%;
  text-align: center;
  font-family: 'Roboto';
  font-size: 20px;
`

const KukoMailInput = styled.input`
  &:focus {
        outline: none;
    }
  -webkit-appearance: none;
  border: 1px solid #aa9999;
  border-radius: 8px;
  background-color: transparent;
  font-size: 40px;
  text-align: center;
  font-family: 'Roboto';
  padding: 8px;
  margin: 30px;
  max-width: 80%;
`

const KukoButton = styled.div`
  border-radius: 8px;
  padding: 12px;
  background-color: #ffffff;
  cursor: pointer;
  transition: opacity 1s ease-in-out;
  margin: 30px;

  & span {
  font-size: 20px;
  text-align: center;
  font-family: 'Roboto';
  }
`

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

  const [email, setEmail] = useState('');
  const [valid, setValidEmail] = useState(false);
  const [enrolled, setEnrolled] = useState(false);
  const [error, setError] = useState(false);
  const [clicked, setClicked] = useState(false);

  useEffect(() => {
    setValidEmail(isValidEmail(email));
  }, [email]);

  useEffect(() => {
    if (!enrolled && valid && clicked) {
      fetch('https://waitlist.kuko.finance/api?mail=' + email)
      .then((res) => {
        setClicked(false);
        if (res.status !== 200) {
          setEnrolled(false);
          setError(true);
        } else {
          setEnrolled(true)
        }
      })
    }
  }, [enrolled, email, valid, clicked]);

  return (
    <StyledApp>
      <GlobalStyle />
      <Kuko role='img' aria-label='kuko'>🎂</Kuko>
      <KukoDesc>Kuko is a brand new way of earning competitive staking interests on Ethereum while being 100% decentralized. Enroll in our waiting list now to receive updates.</KukoDesc>
      <KukoMailInput
        value={email}
        onChange={(e) => setEmail(e.target.value)}
      />
      {
        enrolled
          ?
          <KukoDesc>Thank you !</KukoDesc>
          :
          <KukoButton
          onClick={() => setClicked(true)}
            style={{
              opacity: valid ? '1' : '0'
            }}
          ><span>Enroll</span></KukoButton>
      }
    </StyledApp>
  );
}

export default App;
