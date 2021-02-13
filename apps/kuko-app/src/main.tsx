import React from 'react';
import ReactDOM from 'react-dom';
import { ThemeProvider, createGlobalStyle } from 'styled-components';

import App from './app/app';
import { theme, KukoTheme } from '@kuko-finance/kukore-react';

const GlobalStyle = createGlobalStyle`

  html, #root {
    font-family: 'Lato', sans-serif;
    width: 100%;
    height: 100%;
    color: ${(props: any) => props.theme.textColor};
  }

  body {
    margin: 0;
    height: 100%;
    width: 100%;
  }
`;

ReactDOM.render(
  <React.StrictMode>
    <ThemeProvider theme={theme}>
      <GlobalStyle />
      <App />
    </ThemeProvider>
  </React.StrictMode>,
  document.getElementById('root')
);
