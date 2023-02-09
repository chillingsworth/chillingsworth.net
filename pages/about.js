import Head from 'next/head'
import Image from 'next/image'
import { useRouter } from 'next/router'
import { Inter } from '@next/font/google'
import styles from '@/styles/Home.module.css'

const inter = Inter({ subsets: ['latin'] })


export default function About() {

  let router= useRouter()

  function redirectHome() {   
    router.push('/')
  }

  return (
    <>
      <Head>
        <title>Create Next App</title>
        <meta name="description" content="Generated by create next app" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <main>
        <div className={styles.main_layout}>
          <div className={styles.header_main}>
            <h1 className={styles.header_item} onClick={redirectHome}>
              Chillingsworth 🏖️
            </h1>
            <div className={styles.header_item}>
              About
            </div>
          </div>
          <div className={styles.body_header_item}>
            <div className={styles.about_area}>
                <p>
                Hi, my name's Joshua Killingsworth. I'm a NYC-based husband, father, entrepreneur, machine learning engineer, and book-worm.
                </p>
                <p>
                If you're interested in learning more about me professionally, feel free to reach out to me on LinkedIn: https://www.linkedin.com/in/josh-killingsworth/
                </p>
                <p>
                I love meeting new clients/friends, so if you're interested in grabbing a coffe together (in Manhattan), please feel free to email me at josh.kwth@gmail.com
                </p>
            </div>
          </div>
        </div>
      </main>
    </>
  )
}
