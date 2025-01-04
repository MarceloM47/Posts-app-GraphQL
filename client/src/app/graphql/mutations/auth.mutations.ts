import { gql } from 'apollo-angular';

export const LOGIN_MUTATION = gql`
  mutation Login($input: LoginInput!) {
    login(input: $input) {
      token,
      errors,
      account {
        id,
        email,
        name,
      }
    }
  }
`;
