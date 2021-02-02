import React from 'react';
import styled, {createGlobalStyle} from 'styled-components';

const StyledApp = styled.div`
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #ffe0e0;
`;

const Kuko = styled.span`
  font-size: 60px;
`;

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
  return (
    <StyledApp>
      <GlobalStyle/>
      <Kuko role='img' aria-label='kuko'>🎂</Kuko>
    </StyledApp>
  );
}

export default App;
