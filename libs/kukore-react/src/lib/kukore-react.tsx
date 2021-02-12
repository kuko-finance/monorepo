import React from 'react';

import styled from 'styled-components';

/* eslint-disable-next-line */
export interface KukoreReactProps {}

const StyledKukoreReact = styled.div`
  color: pink;
`;

export function KukoreReact(props: KukoreReactProps) {
  return (
    <StyledKukoreReact>
      <h1>Welcome to kukore-react!</h1>
    </StyledKukoreReact>
  );
}

export default KukoreReact;
