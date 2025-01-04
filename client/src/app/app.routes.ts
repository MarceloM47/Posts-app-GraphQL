import { Routes } from '@angular/router';
import { LoginComponent } from './views/login/login.component';
import { authGuard, loginGuard } from './guards/auth.guard';

export const routes: Routes = [
    { 
        path: '', 
        redirectTo: '/login', 
        pathMatch: 'full' 
    },
    { 
        path: 'login', 
        component: LoginComponent,
        canActivate: [loginGuard]
    },
    { 
        path: 'posts', 
        loadComponent: () => import('./views/posts/posts.component')
            .then(m => m.PostsComponent),
        canActivate: [authGuard]
    },
    { 
        path: '**', 
        redirectTo: '/login' 
    }
];
