import { memo, SVGProps } from 'react';

const VectorIcon = (props: SVGProps<SVGSVGElement>) => (
  <svg preserveAspectRatio='none' viewBox='0 0 11 11' fill='none' xmlns='http://www.w3.org/2000/svg' {...props}>
    <path
      d='M7.76627 0.0265729C7.87368 0.0716835 7.95101 0.168349 7.97249 0.2822L8.39997 2.60003L10.7178 3.02536C10.8317 3.04684 10.9283 3.12417 10.9734 3.23158C11.0185 3.33898 11.0056 3.46143 10.9391 3.55809L9.60077 5.5L10.9391 7.43976C11.0056 7.53642 11.0185 7.65887 10.9734 7.76627C10.9283 7.87368 10.8317 7.95101 10.7178 7.97249L8.39997 8.39997L7.97249 10.7178C7.95101 10.8317 7.87368 10.9283 7.76627 10.9734C7.65887 11.0185 7.53642 11.0056 7.43976 10.9391L5.5 9.60077L3.56024 10.9391C3.46358 11.0056 3.34113 11.0185 3.23373 10.9734C3.12632 10.9283 3.04899 10.8317 3.02751 10.7178L2.60003 8.39997L0.2822 7.97249C0.168349 7.95101 0.0716835 7.87368 0.0265729 7.76627C-0.0185378 7.65887 -0.00564905 7.53642 0.0609429 7.43976L1.39923 5.5L0.0609429 3.56024C-0.00564905 3.46358 -0.0185378 3.34113 0.0265729 3.23373C0.0716835 3.12632 0.168349 3.04899 0.2822 3.02751L2.60003 2.60003L3.02751 0.2822C3.04899 0.168349 3.12632 0.0716835 3.23373 0.0265729C3.34113 -0.0185378 3.46358 -0.00564905 3.56024 0.0609429L5.5 1.39923L7.43976 0.0609429C7.53642 -0.00564905 7.65887 -0.0185378 7.76627 0.0265729ZM3.4378 5.5C3.4378 4.95307 3.65507 4.42854 4.0418 4.0418C4.42854 3.65507 4.95307 3.4378 5.5 3.4378C6.04693 3.4378 6.57146 3.65507 6.9582 4.0418C7.34493 4.42854 7.5622 4.95307 7.5622 5.5C7.5622 6.04693 7.34493 6.57146 6.9582 6.9582C6.57146 7.34493 6.04693 7.5622 5.5 7.5622C4.95307 7.5622 4.42854 7.34493 4.0418 6.9582C3.65507 6.57146 3.4378 6.04693 3.4378 5.5ZM8.2496 5.5C8.2496 4.77076 7.95991 4.07139 7.44426 3.55574C6.92861 3.04009 6.22924 2.7504 5.5 2.7504C4.77076 2.7504 4.07139 3.04009 3.55574 3.55574C3.04009 4.07139 2.7504 4.77076 2.7504 5.5C2.7504 6.22924 3.04009 6.92861 3.55574 7.44426C4.07139 7.95991 4.77076 8.2496 5.5 8.2496C6.22924 8.2496 6.92861 7.95991 7.44426 7.44426C7.95991 6.92861 8.2496 6.22924 8.2496 5.5Z'
      fill='white'
    />
  </svg>
);

const Memo = memo(VectorIcon);
export { Memo as VectorIcon };
