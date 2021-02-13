import React from 'react';
import styled from '../styled';
import MediaQuery from 'react-responsive';
import { DesktopAccountWidget } from './desktop';
import { MobileAccountWidget } from './mobile';

export * from './context';

export const AccountWidget = () => {
  return (
    <>
      <MediaQuery minWidth={1224}>
        <DesktopAccountWidget />
      </MediaQuery>
      <MediaQuery maxWidth={1223}>
        <MobileAccountWidget />
      </MediaQuery>
    </>
  );
};
