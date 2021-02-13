export interface KukoTheme {
  primaryColor: string;
  textColor: string;
  spacing: {
    small: string;
    normal: string;
    big: string;
  };
  radius: {
    small: string;
    normal: string;
    big: string;
  };
  fallbackBackground: string;
  blurBackground: string;
  defaultBlur: string;
}

export const theme: KukoTheme = {
  primaryColor: '#f1d1d0',
  textColor: '#7C6766',
  spacing: {
    small: '8px',
    normal: '16px',
    big: '32px',
  },
  radius: {
    small: '8px',
    normal: '16px',
    big: '32px',
  },
  fallbackBackground: '#f1d1d099',
  blurBackground: '#f1d1d050',
  defaultBlur: '32px',
};
