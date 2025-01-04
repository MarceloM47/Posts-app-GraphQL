import { ApplicationConfig, inject } from '@angular/core';
import { provideRouter } from '@angular/router';
import { routes } from './app.routes';
import { provideHttpClient } from '@angular/common/http';
import { provideApollo } from 'apollo-angular';
import { InMemoryCache } from '@apollo/client/core';
import { HttpLink } from 'apollo-angular/http';

export const appConfig: ApplicationConfig = {
  providers: [
    provideHttpClient(),
    provideRouter(routes),
    provideApollo(() => {
      const httpLink = inject(HttpLink);
      return {
        cache: new InMemoryCache(),
        link: httpLink.create({
          uri: 'http://localhost:3000/graphql'
        })
      };
    })
  ]
};
