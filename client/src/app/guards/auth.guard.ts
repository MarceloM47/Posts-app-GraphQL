import { inject } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../graphql/services/auth.service';

export const authGuard = () => {
  const authService = inject(AuthService);
  const router = inject(Router);

  if (!authService.isAuthenticated()) {
    return router.createUrlTree(['/login']);
  }

  return true;
};

export const loginGuard = () => {
  const authService = inject(AuthService);
  const router = inject(Router);

  if (authService.isAuthenticated()) {
    return router.createUrlTree(['/posts']);
  }

  return true;
};
