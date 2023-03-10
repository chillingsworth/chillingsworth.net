import Head from 'next/head'
import Image from 'next/image'
import { useRouter } from 'next/router'
import { Inter } from '@next/font/google'
import styles from '../styles/Home.module.css'
import posts from '../postdata/posts.json';
import PostPreview from './post-preview'
import React, { useState } from 'react';

const inter = Inter({ subsets: ['latin'] })

export default function Header() {

  let router= useRouter()

  function redirectAbout() {   
    router.push('/about')
  }

  function redirectHome() {   
    router.push('/')
  }


  // const [getPosts, setPosts] = useState(posts);

  return (
    <>
      <Head>
        <title>Create Next App</title>
        <meta name="description" content="Generated by create next app" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <main >
        <div className={styles.main_layout}>
          <div className={styles.header_main}>
            <h1 className={styles.header_item} onClick={redirectHome}>
              Chillingsworth 🏖️
            </h1>
            <div className={styles.header_item} onClick={redirectAbout}>
              About
            </div>
          </div>
        </div>
        </main>
    </>)
}
