// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	integrations: [
		starlight({
			title: 'LM+ Locator',
			social: [
				{ icon: 'github', label: 'GitHub', href: 'https://github.com/symonxdd/lm-plus-locator' },
			],
			sidebar: [
				{ label: 'Overview', link: '/' },
				{ label: 'Architecture', link: '/architecture/' },
				{ label: 'Features', link: '/features/' },
				{ label: 'Office data pipeline', link: '/data-pipeline/' },
			],
		}),
	],
});
